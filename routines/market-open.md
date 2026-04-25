# Routine: Market Open

Runs ~9:35 AM ET on weekdays. Purpose: execute only approved trades from today's research.

## Environment Check

```bash
for v in ALPACA_API_KEY ALPACA_SECRET_KEY ALPACA_ENDPOINT CLAUDE_API_KEY EMAIL_TO EMAIL_FROM EMAIL_APP_PASSWORD SMTP_HOST SMTP_PORT; do
  [[ -n "${!v:-}" ]] && echo "$v: set" || echo "$v: MISSING"
done
```

## Steps

### 1. Resolve date
```bash
DATE=$(date +%Y-%m-%d)
```

### 2. Read memory
- memory/TRADING-STRATEGY.md
- memory/RESEARCH-LOG.md
- memory/TRADE-LOG.md

### 3. Verify today's research exists
If today's entry is missing from RESEARCH-LOG.md: run the pre-market routine first. Never trade without documented research.

### 4. Pull live state
```bash
bash scripts/alpaca.sh account
bash scripts/alpaca.sh positions
bash scripts/alpaca.sh orders
bash scripts/alpaca.sh clock
```

Confirm market is open before placing orders.

### 5. Run buy-side gate for each planned trade
All checks must pass:
- Instrument is a stock.
- Total positions after fill ≤ 6.
- New trades this week ≤ 3.
- Position cost ≤ 20% of equity.
- Position cost ≤ available cash.
- Daytrade count leaves room under PDT.
- Specific catalyst documented in today's RESEARCH-LOG.md.
- Sector momentum supports the trade.
- Target provides ≥ 2:1 risk/reward.

If any check fails: skip trade, log skipped trade and failed rule.

### 6. Get fresh quote
```bash
bash scripts/alpaca.sh quote TICKER
```

Check spread. If wide spread, zero bid, or zero ask: skip.

### 7. Place market buy
```bash
bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"buy","type":"market","time_in_force":"day"}'
```

### 8. Place trailing stop immediately after fill
```bash
bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"trailing_stop","trail_percent":"10","time_in_force":"gtc"}'
```

### 9. If trailing stop rejected (PDT), place fixed stop
```bash
bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"stop","stop_price":"X.XX","time_in_force":"gtc"}'
```

### 10. If fixed stop also rejected
Log: "PDT-blocked stop. Must place stop tomorrow morning."
Send urgent email:
```bash
bash scripts/email.sh "URGENT: Stop Blocked $DATE" "PDT restriction blocked stop for SYM. Manual stop required tomorrow."
```

### 11. Log to memory/TRADE-LOG.md

### 12. Email if trade placed
```bash
bash scripts/email.sh "Market Open Trade $DATE" "BUY SYM N shares @ $X | Stop: $X | Thesis: ..."
```

### 13. Commit and push if trades executed
```bash
git add memory/TRADE-LOG.md
git commit -m "market-open trades $DATE"
git push origin main
```
