# Routine: Pre-Market Research

Runs ~8:30 AM ET on weekdays. Purpose: create the day's research plan before market open.

## Environment Check

```bash
for v in ALPACA_API_KEY ALPACA_SECRET_KEY ALPACA_ENDPOINT CLAUDE_API_KEY EMAIL_TO EMAIL_FROM EMAIL_APP_PASSWORD SMTP_HOST SMTP_PORT; do
  [[ -n "${!v:-}" ]] && echo "$v: set" || echo "$v: MISSING"
done
```

If any required variable is missing: stop, send alert email if possible, do not proceed.

## Steps

### 1. Resolve date
```bash
DATE=$(date +%Y-%m-%d)
```

### 2. Read memory
- memory/TRADING-STRATEGY.md
- memory/TRADE-LOG.md
- memory/RESEARCH-LOG.md
- memory/PROJECT-CONTEXT.md

### 3. Pull live state
```bash
bash scripts/alpaca.sh account
bash scripts/alpaca.sh positions
bash scripts/alpaca.sh orders
bash scripts/alpaca.sh clock
```

### 4. Run market research
```bash
bash scripts/claude-research.sh "WTI and Brent oil price right now"
bash scripts/claude-research.sh "S&P 500 futures premarket today"
bash scripts/claude-research.sh "VIX level today"
bash scripts/claude-research.sh "Top stock market catalysts today $DATE"
bash scripts/claude-research.sh "Earnings reports before market open today $DATE"
bash scripts/claude-research.sh "Economic calendar today CPI PPI FOMC jobs data $DATE"
bash scripts/claude-research.sh "S&P 500 sector momentum today"
```

Research every currently held ticker:
```bash
bash scripts/claude-research.sh "Latest news and price action for TICKER $DATE"
```

### 5. Generate trade ideas
Identify 1–3 ideas that pass the buy-side gate. For each:
- Ticker, catalyst, entry range, stop, target, R:R (must be ≥ 2:1)
- Sector momentum check
- PDT headroom check

### 6. Append to memory/RESEARCH-LOG.md
Use the standard template format.

### 7. Email only if urgent
```bash
bash scripts/email.sh "Pre-Market Alert $DATE" "<urgent summary>"
```

### 8. Commit and push
```bash
git add memory/RESEARCH-LOG.md
git commit -m "pre-market research $DATE"
git push origin main
```

If push fails due to remote change:
```bash
git pull --rebase origin main
git push origin main
```
