<div align="center">

# NemoFish

**Swarm Intelligence Prediction Engine powered by NVIDIA NIM**

[![NVIDIA NIM](https://img.shields.io/badge/NVIDIA-NIM%20253B-76B900?style=flat-square&logo=nvidia&logoColor=white)](https://build.nvidia.com/)
[![Neo4j](https://img.shields.io/badge/Neo4j-Knowledge%20Graph-4581C3?style=flat-square&logo=neo4j&logoColor=white)](https://neo4j.com/)
[![x402](https://img.shields.io/badge/x402-USDC%20Payments-2775CA?style=flat-square)](https://www.x402.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](./LICENSE)

Spawn thousands of AI agents with NIM 253B brains into simulated worlds. Predict market movements, hackathon outcomes, content performance, and competitive dynamics.

</div>

---

## How It Works

Upload any document -- a financial report, press release, market analysis, policy draft -- and NemoFish builds a parallel world of autonomous AI agents powered by NVIDIA NIM. Each agent has a unique personality, memory, and opinion. They interact, argue, shift positions, and surface emergent predictions that no single model could produce.

**$2 per prediction via x402 USDC. 3 free runs to start.**

## Quick Start

### Docker (recommended)

```bash
git clone https://github.com/ExpertVagabond/nemofish.git
cd nemofish
cp .env.example .env
# Add your NVIDIA NIM API key to .env (free at build.nvidia.com)

docker compose up -d nemofish neo4j
```

Open `http://localhost:3000`.

### Manual

```bash
# 1. Start Neo4j
docker run -d --name neo4j \
  -p 7474:7474 -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/nemofish \
  neo4j:5.18-community

# 2. Configure
cp .env.example .env
# Edit .env with your NVIDIA NIM API key

# 3. Backend
cd backend
pip install -r requirements.txt
python run.py

# 4. Frontend
cd frontend
npm install && npm run dev
```

### CLI Runner

```bash
./run-prediction.sh data/market-report.pdf "Will SOL break $300 by Q3 2026?" "sol-forecast"
```

## API Reference

The prediction pipeline runs in 7 steps:

| Step | Endpoint | Method | Description |
|------|----------|--------|-------------|
| 1 | `/api/payment/verify` | POST | Verify x402 payment or free tier |
| 2 | `/api/graph/ontology/generate` | POST | Upload files + generate ontology |
| 3 | `/api/graph/build` | POST | Build Neo4j knowledge graph |
| 4 | `/api/simulation/create` | POST | Create simulation from project |
| 5 | `/api/simulation/prepare` | POST | Generate agent personas |
| 6 | `/api/simulation/start` | POST | Run swarm simulation |
| 7 | `/api/report/generate` | POST | Generate prediction report |

### Payment Endpoints

```bash
# Check free tier / payment status
curl -X POST http://localhost:5001/api/payment/verify \
  -H "Content-Type: application/json" \
  -d '{"wallet_address": "So1abc..."}'

# Check usage
curl http://localhost:5001/api/payment/usage/So1abc...
```

### Running a Prediction

```bash
# Upload document and generate ontology (payment checked here)
curl -X POST http://localhost:5001/api/graph/ontology/generate \
  -H "X-Wallet-Address: So1abc..." \
  -F "files=@report.pdf" \
  -F "simulation_requirement=Will BTC hit 200K by EOY?"

# Build knowledge graph
curl -X POST http://localhost:5001/api/graph/build \
  -H "Content-Type: application/json" \
  -d '{"project_id": "proj_xxx"}'

# Poll build status
curl http://localhost:5001/api/graph/task/task_xxx

# Create + prepare + start simulation
curl -X POST http://localhost:5001/api/simulation/create \
  -H "Content-Type: application/json" \
  -d '{"project_id": "proj_xxx"}'

# Generate final prediction report
curl -X POST http://localhost:5001/api/report/generate \
  -H "Content-Type: application/json" \
  -d '{"simulation_id": "sim_xxx", "question": "Will BTC hit 200K?"}'
```

## Pricing

| Tier | Price | Limit |
|------|-------|-------|
| Free | $0 | 3 predictions per wallet |
| Standard | $2 USDC | Unlimited (via x402) |

Payments use the [x402 protocol](https://www.x402.org/) -- a native HTTP payment standard. Send USDC with your prediction request via the `X-Payment-402` header.

## Why NVIDIA NIM

NemoFish uses NVIDIA NIM's free-tier API with 253 billion parameter models -- the best available reasoning for financial and strategic analysis. NIM provides:

- **253B parameters** -- larger than any open model, comparable to frontier closed models
- **Free tier** -- 40 requests/minute at no cost via build.nvidia.com
- **Best-in-class reasoning** -- Nemotron and Llama 3.3 models optimized for analytical tasks
- **No local GPU needed** -- runs on NVIDIA's infrastructure, you just need Docker + Neo4j

## Architecture

```
Client (Vue.js)
    |
    v
Flask API  ------>  x402 Payment Gate
    |                    |
    v                    v
NIM 253B (LLM)    Neo4j (Wallet Usage)
    |
    v
Neo4j Knowledge Graph
    |
    v
OASIS Multi-Agent Simulation
    |
    v
ReportAgent -> Structured Prediction
```

## Configuration

All settings in `.env`:

```bash
# NVIDIA NIM (get free key at build.nvidia.com)
LLM_API_KEY=nvapi-xxx
LLM_BASE_URL=https://integrate.api.nvidia.com/v1
LLM_MODEL_NAME=nvidia/llama-3.3-nemotron-super-49b-v1

# Embeddings
EMBEDDING_MODEL=nvidia/nv-embedqa-e5-v5
EMBEDDING_BASE_URL=https://integrate.api.nvidia.com

# Neo4j
NEO4J_URI=bolt://localhost:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=nemofish
```

## Use Cases

- **Market predictions** -- feed financial news, observe simulated trader sentiment and price predictions
- **Hackathon outcomes** -- upload track descriptions, predict winning categories and strategies
- **Content performance** -- simulate audience reaction to content before publishing
- **Policy impact** -- test draft regulations against simulated public response
- **Competitive analysis** -- model how markets react to competitor announcements

## License

MIT
