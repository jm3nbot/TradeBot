# Routine: Weekly Review

Runs Friday ~5:00 PM ET. Purpose: review performance and improve strategy only when evidence supports it.

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
- memory/WEEKLY-REVIEW.md
- memory/TRADE-LOG.md
- memory/RESEARCH-LOG.md
- memory/TRADING-STRATEGY.md

### 3. Pull account and positions
```bash
bash scripts/alpaca.sh account
bash scripts/alpaca.sh positions
```

### 4. Research S&P 500 weekly performance
```bash
bash scripts/claude-research.sh "S&P 500 weekly performance week ending $DATE"
```

### 5. Compute weekly metrics
- Starting portfolio (from Monday's or last week's EOD snapshot in TRADE-LOG.md).
- Ending portfolio.
- Week return in dollars and percent.
- S&P 500 week return.
- Bot vs S&P spread.
- Total trades: W:X wins / L:Y losses / open:Z.
- Win rate.
- Best trade (ticker and percent gain).
- Worst trade (ticker and percent loss).
- Profit factor = gross wins / gross losses.

### 6. Append to memory/WEEKLY-REVIEW.md
Use standard template format.

### 7. Update memory/TRADING-STRATEGY.md only if
- A rule has proven itself for ≥ 2 weeks, OR
- A rule has failed badly (multiple consecutive losses clearly caused by the rule).
Do not change strategy speculatively.

### 8. Include weekly review in the Friday EOD PDF
Do not send a separate weekly email. Merge into the daily PDF.

### 9. Commit and push
```bash
# If strategy changed:
git add memory/WEEKLY-REVIEW.md memory/TRADING-STRATEGY.md
git commit -m "weekly review $DATE"
git push origin main

# If strategy unchanged:
git add memory/WEEKLY-REVIEW.md
git commit -m "weekly review $DATE"
git push origin main
```
