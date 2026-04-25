Read-only portfolio snapshot. No orders. No file writes. No emails unless something is broken.

Steps:
1. Resolve date: DATE=$(date +%Y-%m-%d)
2. Run:
   bash scripts/alpaca.sh account
   bash scripts/alpaca.sh positions
   bash scripts/alpaca.sh orders

3. Format and print output exactly as:

```
Portfolio - YYYY-MM-DD
Equity: $X | Cash: $X (X%) | Buying power: $X
Daytrade count: N

Positions:
SYM | Shares | Entry -> Now | Unrealized P&L % | Stop type | Stop price

Open orders:
TYPE | SYM | qty | trail%/stop_price | order_id | status
```

4. Flag anything unusual: missing stops, positions with unrealized loss near –7%, stops within 3% of price.
