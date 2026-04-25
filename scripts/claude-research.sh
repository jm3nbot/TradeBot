#!/usr/bin/env bash
set -euo pipefail

query="${1:-}"
if [[ -z "$query" ]]; then
  echo "usage: bash scripts/claude-research.sh \"<query>\"" >&2
  exit 1
fi

: "${CLAUDE_API_KEY:?CLAUDE_API_KEY not set in environment}"

CLAUDE_MODEL="${CLAUDE_MODEL:-claude-sonnet-4-6}"

python3 - <<PY
import json, os, sys
import urllib.request, urllib.error

query = """$query"""
api_key = os.environ["CLAUDE_API_KEY"]
model = os.environ.get("CLAUDE_MODEL", "claude-sonnet-4-6")

payload = {
    "model": model,
    "max_tokens": 1200,
    "tools": [{"type": "web_search_20250305", "name": "web_search"}],
    "messages": [{
        "role": "user",
        "content": (
            "Research this market question concisely. Include current context, "
            "trading relevance, risks, and any uncertainty: " + query
        )
    }]
}

req = urllib.request.Request(
    "https://api.anthropic.com/v1/messages",
    data=json.dumps(payload).encode(),
    headers={
        "x-api-key": api_key,
        "anthropic-version": "2023-06-01",
        "anthropic-beta": "web-search-2025-03-05",
        "content-type": "application/json",
    },
    method="POST"
)

try:
    with urllib.request.urlopen(req) as resp:
        data = json.loads(resp.read())
except urllib.error.HTTPError as e:
    body = e.read().decode()
    print(f"[claude-research error {e.code}] {body}", file=sys.stderr)
    sys.exit(1)

for block in data.get("content", []):
    if block.get("type") == "text":
        print(block["text"])
PY
