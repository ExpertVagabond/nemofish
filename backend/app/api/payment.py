"""
x402 Payment Verification API

Implements payment gating for NemoFish predictions:
- Free tier: 3 predictions per wallet address (tracked in Neo4j)
- Paid tier: $2 USDC per prediction via x402 payment header
- Endpoint: /api/payment/*
"""

import time
from flask import request, jsonify, current_app

from . import payment_bp
from ..utils.logger import get_logger

logger = get_logger('nemofish.payment')

# x402 payment configuration
PREDICTION_PRICE_USDC = 2.00
FREE_TIER_LIMIT = 3
X402_HEADER = 'X-Payment-402'


def _get_storage():
    """Get Neo4jStorage from Flask app extensions."""
    storage = current_app.extensions.get('neo4j_storage')
    if not storage:
        raise ValueError("GraphStorage not initialized -- check Neo4j connection")
    return storage


def _get_wallet_usage(wallet_address: str) -> dict:
    """
    Query Neo4j for wallet prediction usage.

    Returns dict with:
        - total_predictions: int
        - free_remaining: int
        - is_free_tier: bool
    """
    try:
        storage = _get_storage()
        if storage is None:
            # Neo4j not connected -- allow free tier by default
            return {
                'total_predictions': 0,
                'free_remaining': FREE_TIER_LIMIT,
                'is_free_tier': True,
            }

        driver = storage._driver
        with driver.session() as session:
            result = session.run(
                """
                MERGE (w:Wallet {address: $address})
                ON CREATE SET w.created_at = timestamp(), w.prediction_count = 0
                RETURN w.prediction_count AS count
                """,
                address=wallet_address.lower(),
            )
            record = result.single()
            count = record['count'] if record else 0

        free_remaining = max(0, FREE_TIER_LIMIT - count)
        return {
            'total_predictions': count,
            'free_remaining': free_remaining,
            'is_free_tier': count < FREE_TIER_LIMIT,
        }
    except Exception as e:
        logger.warning(f"Failed to query wallet usage: {e}")
        # Fail open: allow request
        return {
            'total_predictions': 0,
            'free_remaining': FREE_TIER_LIMIT,
            'is_free_tier': True,
        }


def _increment_wallet_usage(wallet_address: str) -> None:
    """Increment the prediction count for a wallet in Neo4j."""
    try:
        storage = _get_storage()
        if storage is None:
            return

        driver = storage._driver
        with driver.session() as session:
            session.run(
                """
                MERGE (w:Wallet {address: $address})
                ON CREATE SET w.created_at = timestamp(), w.prediction_count = 1
                ON MATCH SET w.prediction_count = w.prediction_count + 1,
                             w.last_prediction_at = timestamp()
                """,
                address=wallet_address.lower(),
            )
    except Exception as e:
        logger.warning(f"Failed to increment wallet usage: {e}")


def verify_payment(wallet_address: str = None) -> tuple[bool, str]:
    """
    Verify x402 payment or free tier eligibility.

    Returns:
        (is_authorized, reason)
    """
    # Check for x402 payment header
    payment_header = request.headers.get(X402_HEADER)

    if payment_header:
        # In production, this would verify the x402 payment proof on-chain.
        # For now, accept any non-empty payment header as valid.
        # TODO: Integrate actual x402 USDC verification (Coinbase x402 SDK)
        logger.info(f"x402 payment received from wallet {wallet_address or 'unknown'}")
        return True, 'paid'

    # No payment header -- check free tier
    if not wallet_address:
        wallet_address = request.headers.get('X-Wallet-Address', 'anonymous')

    usage = _get_wallet_usage(wallet_address)

    if usage['is_free_tier']:
        return True, f"free_tier ({usage['free_remaining']} remaining)"

    return False, 'payment_required'


# ============== Payment Endpoints ==============

@payment_bp.route('/verify', methods=['POST'])
def verify_payment_endpoint():
    """
    Verify x402 payment or free tier eligibility.

    Request (JSON):
        {
            "wallet_address": "0x..." or "So1..."  (optional)
        }

    Headers:
        X-Payment-402: <x402 payment proof>  (optional)
        X-Wallet-Address: <wallet address>    (optional fallback)

    Response:
        {
            "success": true,
            "data": {
                "authorized": true,
                "reason": "free_tier (2 remaining)",
                "price_usdc": 2.00,
                "free_tier_limit": 3
            }
        }
    """
    data = request.get_json(silent=True) or {}
    wallet_address = data.get('wallet_address') or request.headers.get('X-Wallet-Address', 'anonymous')

    authorized, reason = verify_payment(wallet_address)

    status_code = 200 if authorized else 402

    return jsonify({
        'success': authorized,
        'data': {
            'authorized': authorized,
            'reason': reason,
            'price_usdc': PREDICTION_PRICE_USDC,
            'free_tier_limit': FREE_TIER_LIMIT,
            'wallet': wallet_address,
        }
    }), status_code


@payment_bp.route('/usage/<wallet>', methods=['GET'])
def get_usage(wallet: str):
    """
    Check remaining free predictions for a wallet.

    Response:
        {
            "success": true,
            "data": {
                "wallet": "0x...",
                "total_predictions": 1,
                "free_remaining": 2,
                "is_free_tier": true,
                "price_usdc": 2.00
            }
        }
    """
    usage = _get_wallet_usage(wallet)

    return jsonify({
        'success': True,
        'data': {
            'wallet': wallet,
            **usage,
            'price_usdc': PREDICTION_PRICE_USDC,
        }
    })


@payment_bp.route('/record', methods=['POST'])
def record_prediction():
    """
    Record a completed prediction (called internally after successful run).

    Request (JSON):
        {
            "wallet_address": "0x...",
            "project_id": "proj_xxx"
        }
    """
    data = request.get_json(silent=True) or {}
    wallet_address = data.get('wallet_address', 'anonymous')
    project_id = data.get('project_id', '')

    _increment_wallet_usage(wallet_address)

    logger.info(f"Prediction recorded: wallet={wallet_address}, project={project_id}")

    return jsonify({
        'success': True,
        'message': 'Prediction recorded',
    })
