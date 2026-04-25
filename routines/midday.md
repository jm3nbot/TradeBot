# Routine: Midday Scan

Runs ~12:30 PM ET on weekdays. Purpose: manage open positions and enforce risk rules.

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
- memory/TRADE-LOG.md
- memory/RESEARCH-LOG.md (today's entry)

### 3. Pull current state
```bash
bash scripts/alpaca.sh positions
bash scripts/alpaca.sh orders
```

### 4. Hard cut at –7%
For each position with unrealized loss ≥ –7%:
```bash
bash scripts/alpaca.sh close SYM
```
Cancel any open stop orders for that symbol:
```bash
bash scripts/alpaca.sh cancel <order_id>
```
Log exit to memory/TRADE-LOG.md.

### 5. Check stop tightening on winners
For each position:
- Up ≥ 15%: tighten to 7% trailing stop.
- Up ≥ 20%: tighten to 5% trailing stop.
- Check: new stop must not be within 3% of current price.
- Never move stop down.

To replace:
```bash
bash scripts/alpaca.sh cancel <old_stop_order_id>
bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"trailing_stop","trail_percent":"X","time_in_force":"gtc"}'
```

### 6. Thesis review
For each position, verify thesis is still intact. If price action is unexplained:
```bash
bash scripts/claude-research.sh "Why is TICKER moving today $DATE"
```

Exit if thesis is broken, catalyst is invalidated, or sector rolls over sharply.

### 7. Sector check
If any sector has 2 consecutive failed trades: mark it as no-trade in TRADE-LOG.md.

### 8. Log all actions
Append exits, stop changes, thesis updates to memory/TRADE-LOG.md.

### 9. Email only if action taken
```bash
bash scripts/email.sh "Midday Action $DATE" "<action summary: what changed and why>"
```

### 10. Commit and push if memory changed
```bash
git add memory/TRADE-LOG.md
git commit -m "midday scan $DATE"
git push origin main
```
