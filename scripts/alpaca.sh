#!/usr/bin/env bash
set -euo pipefail

: "${ALPACA_API_KEY:?ALPACA_API_KEY not set}"
: "${ALPACA_SECRET_KEY:?ALPACA_SECRET_KEY not set}"
: "${ALPACA_ENDPOINT:?ALPACA_ENDPOINT not set}"
ALPACA_DATA_ENDPOINT="${ALPACA_DATA_ENDPOINT:-https://data.alpaca.markets}"

_auth() {
  echo -H "APCA-API-KEY-ID: $ALPACA_API_KEY" -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY"
}

cmd="${1:-}"
shift || true

case "$cmd" in
  account)
    curl -fsS \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      "$ALPACA_ENDPOINT/v2/account" | python3 -m json.tool
    ;;

  positions)
    curl -fsS \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      "$ALPACA_ENDPOINT/v2/positions" | python3 -m json.tool
    ;;

  orders)
    STATUS="${1:-open}"
    curl -fsS \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      "$ALPACA_ENDPOINT/v2/orders?status=$STATUS&limit=50" | python3 -m json.tool
    ;;

  order)
    json="${1:?order requires a JSON body}"
    curl -fsS -X POST \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      -H "Content-Type: application/json" \
      -d "$json" \
      "$ALPACA_ENDPOINT/v2/orders" | python3 -m json.tool
    ;;

  cancel)
    order_id="${1:?cancel requires an order_id}"
    curl -fsS -X DELETE \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      "$ALPACA_ENDPOINT/v2/orders/$order_id"
    echo "cancelled $order_id"
    ;;

  close)
    sym="${1:?close requires a symbol}"
    curl -fsS -X DELETE \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      "$ALPACA_ENDPOINT/v2/positions/$sym" | python3 -m json.tool
    ;;

  quote)
    sym="${1:?quote requires a symbol}"
    curl -fsS \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      "$ALPACA_DATA_ENDPOINT/v2/stocks/$sym/quotes/latest" | python3 -m json.tool
    ;;

  bars)
    sym="${1:?bars requires a symbol}"
    timeframe="${2:-1Day}"
    curl -fsS \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      "$ALPACA_DATA_ENDPOINT/v2/stocks/$sym/bars?timeframe=$timeframe&limit=10" | python3 -m json.tool
    ;;

  clock)
    curl -fsS \
      -H "APCA-API-KEY-ID: $ALPACA_API_KEY" \
      -H "APCA-API-SECRET-KEY: $ALPACA_SECRET_KEY" \
      "$ALPACA_ENDPOINT/v2/clock" | python3 -m json.tool
    ;;

  *)
    echo "usage: bash scripts/alpaca.sh <command> [args]" >&2
    echo "commands: account, positions, orders [status], order '<json>', cancel <order_id>, close <sym>, quote <sym>, bars <sym> [timeframe], clock" >&2
    exit 1
    ;;
esac
