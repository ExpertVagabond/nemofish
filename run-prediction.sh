#!/bin/bash
# NemoFish Programmatic Prediction Runner
# Usage: ./run-prediction.sh <input-file> "<prediction-question>" [project-name]
#
# Example:
#   ./run-prediction.sh data/solana-ecosystem.md "Which Colosseum Frontier track will have the most winners?" "solana-prediction"
#   ./run-prediction.sh data/defi-report.pdf "How will SOL-USDC LP yields change in April 2026?" "defi-forecast"

set -euo pipefail

API="http://localhost:5001"
INPUT_FILE="${1:?Usage: ./run-prediction.sh <file> <question> [name]}"
QUESTION="${2:?Provide a prediction question}"
PROJECT_NAME="${3:-nemofish-$(date +%s)}"

echo "╔══════════════════════════════════════════╗"
echo "║         NEMOFISH PREDICTION              ║"
echo "║         Powered by NVIDIA NIM 253B       ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Input:    $INPUT_FILE"
echo "Question: $QUESTION"
echo "Project:  $PROJECT_NAME"
echo ""

# ─── Step 1: Upload file + generate ontology ─────────────────────────────────
echo "[1/7] Uploading file and generating ontology..."
ONTOLOGY=$(curl -s -X POST "$API/api/graph/ontology/generate" \
  -F "files=@$INPUT_FILE" \
  -F "simulation_requirement=$QUESTION" \
  -F "project_name=$PROJECT_NAME" \
  -F "additional_context=Predict outcomes using swarm intelligence simulation")

PROJECT_ID=$(echo "$ONTOLOGY" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['project_id'])" 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
  echo "ERROR: Ontology generation failed"
  echo "$ONTOLOGY" | python3 -m json.tool 2>/dev/null || echo "$ONTOLOGY"
  exit 1
fi
echo "  Project ID: $PROJECT_ID"
echo "  Ontology generated ✓"

# ─── Step 2: Build knowledge graph ───────────────────────────────────────────
echo "[2/7] Building knowledge graph..."
BUILD=$(curl -s -X POST "$API/api/graph/build" \
  -H "Content-Type: application/json" \
  -d "{\"project_id\": \"$PROJECT_ID\"}")

TASK_ID=$(echo "$BUILD" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['task_id'])" 2>/dev/null)
echo "  Task ID: $TASK_ID"

# Poll until complete
while true; do
  STATUS=$(curl -s "$API/api/graph/task/$TASK_ID" | python3 -c "import sys,json; d=json.load(sys.stdin)['data']; print(d['status'])" 2>/dev/null)
  if [ "$STATUS" = "completed" ]; then
    GRAPH_ID=$(curl -s "$API/api/graph/task/$TASK_ID" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'].get('graph_id',''))" 2>/dev/null)
    echo "  Graph built ✓ ($GRAPH_ID)"
    break
  elif [ "$STATUS" = "failed" ]; then
    echo "  ERROR: Graph build failed"
    exit 1
  fi
  echo "  Building... ($STATUS)"
  sleep 5
done

# ─── Step 3: Create simulation ───────────────────────────────────────────────
echo "[3/7] Creating simulation..."
SIM=$(curl -s -X POST "$API/api/simulation/create" \
  -H "Content-Type: application/json" \
  -d "{\"project_id\": \"$PROJECT_ID\", \"enable_twitter\": true, \"enable_reddit\": true}")

SIM_ID=$(echo "$SIM" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['simulation_id'])" 2>/dev/null)
echo "  Simulation ID: $SIM_ID"

# ─── Step 4: Prepare simulation (generate agent profiles) ────────────────────
echo "[4/7] Preparing simulation (generating agent profiles)..."
PREP=$(curl -s -X POST "$API/api/simulation/prepare" \
  -H "Content-Type: application/json" \
  -d "{\"simulation_id\": \"$SIM_ID\"}")

# Poll preparation status
while true; do
  PREP_STATUS=$(curl -s -X POST "$API/api/simulation/prepare/status" \
    -H "Content-Type: application/json" \
    -d "{\"simulation_id\": \"$SIM_ID\"}" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['status'])" 2>/dev/null)
  if [ "$PREP_STATUS" = "completed" ] || [ "$PREP_STATUS" = "ready" ]; then
    echo "  Profiles generated ✓"
    break
  elif [ "$PREP_STATUS" = "failed" ]; then
    echo "  ERROR: Preparation failed"
    exit 1
  fi
  echo "  Preparing... ($PREP_STATUS)"
  sleep 5
done

# ─── Step 5: Start simulation ────────────────────────────────────────────────
echo "[5/7] Starting simulation (agents interacting)..."
START=$(curl -s -X POST "$API/api/simulation/start" \
  -H "Content-Type: application/json" \
  -d "{\"simulation_id\": \"$SIM_ID\", \"platform\": \"parallel\", \"max_rounds\": 10}")

echo "  Simulation running..."

# Poll run status
while true; do
  RUN=$(curl -s "$API/api/simulation/$SIM_ID/run-status" 2>/dev/null)
  RUN_STATUS=$(echo "$RUN" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['status'])" 2>/dev/null)
  ROUND=$(echo "$RUN" | python3 -c "import sys,json; print(json.load(sys.stdin)['data'].get('current_round','?'))" 2>/dev/null)
  if [ "$RUN_STATUS" = "completed" ] || [ "$RUN_STATUS" = "finished" ]; then
    echo "  Simulation complete ✓ (${ROUND} rounds)"
    break
  elif [ "$RUN_STATUS" = "failed" ] || [ "$RUN_STATUS" = "error" ]; then
    echo "  ERROR: Simulation failed"
    curl -s "$API/api/simulation/$SIM_ID/run-status" | python3 -m json.tool
    exit 1
  fi
  echo "  Round $ROUND... ($RUN_STATUS)"
  sleep 10
done

# ─── Step 6: Generate prediction report ──────────────────────────────────────
echo "[6/7] Generating prediction report..."
REPORT=$(curl -s -X POST "$API/api/report/generate" \
  -H "Content-Type: application/json" \
  -d "{\"simulation_id\": \"$SIM_ID\", \"question\": \"$QUESTION\"}")

REPORT_ID=$(echo "$REPORT" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['report_id'])" 2>/dev/null)

# Poll report generation
while true; do
  RPT_STATUS=$(curl -s "$API/api/report/$REPORT_ID/progress" | python3 -c "import sys,json; print(json.load(sys.stdin)['data']['status'])" 2>/dev/null)
  if [ "$RPT_STATUS" = "completed" ]; then
    echo "  Report generated ✓"
    break
  elif [ "$RPT_STATUS" = "failed" ]; then
    echo "  ERROR: Report generation failed"
    exit 1
  fi
  echo "  Writing report... ($RPT_STATUS)"
  sleep 5
done

# ─── Step 7: Fetch and display report ────────────────────────────────────────
echo "[7/7] Fetching results..."
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "PREDICTION REPORT: $PROJECT_NAME"
echo "════════════════════════════════════════════════════════════════"
echo ""

curl -s "$API/api/report/$REPORT_ID" | python3 -c "
import sys, json
data = json.load(sys.stdin)['data']
print(data.get('content', data.get('report', json.dumps(data, indent=2))))
"

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "IDs for further exploration:"
echo "  Project:    $PROJECT_ID"
echo "  Graph:      $GRAPH_ID"
echo "  Simulation: $SIM_ID"
echo "  Report:     $REPORT_ID"
echo ""
echo "Interview agents:  curl -X POST $API/api/simulation/interview -H 'Content-Type: application/json' -d '{\"simulation_id\": \"$SIM_ID\", \"question\": \"Why did you make that prediction?\"}'"
echo "View posts:        curl $API/api/simulation/$SIM_ID/posts"
echo "View timeline:     curl $API/api/simulation/$SIM_ID/timeline"
echo "Download report:   curl $API/api/report/$REPORT_ID/download -o report.md"
