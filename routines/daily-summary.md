# Routine: Daily Summary and PDF Report

Runs ~4:30 PM ET on weekdays. Purpose: preserve daily state and send one EOD PDF after market close.

Do not send a long plain-text email. Put analysis in the PDF. Send exactly one email with the PDF attached.

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
- memory/TRADE-LOG.md
- memory/RESEARCH-LOG.md (today's entry)

### 3. Pull final state
```bash
bash scripts/alpaca.sh account
bash scripts/alpaca.sh positions
bash scripts/alpaca.sh orders
```

### 4. Research S&P 500 daily performance
```bash
bash scripts/claude-research.sh "S&P 500 daily performance for $DATE, closing performance, major drivers, and sector context"
```

### 5. Compute metrics
- Day P&L in dollars and percent.
- Phase P&L in dollars and percent (since project start on 2026-04-26).
- S&P 500 daily return.
- Bot return minus S&P 500 return.
- Trades placed today and this week.
- Open positions count.
- Stop status for every position.
- Risk exposure by ticker and sector.

### 6. Append EOD snapshot to memory/TRADE-LOG.md

```markdown
### MMM DD EOD Snapshot

**Portfolio:** $X | **Cash:** $X (X%) | **Day P&L:** ±$X (±X%) | **S&P 500:** ±X% | **Bot vs S&P:** ±X% | **Phase P&L:** ±$X (±X%)

| Ticker | Shares | Entry | Close | Day Chg | Unrealized P&L | Stop | Risk Status |
|--------|--------|-------|-------|---------|----------------|------|-------------|

**Notes:** ...
```

### 7. Generate PDF at reports/daily/$DATE-eod-report.pdf

Required PDF sections:
1. Executive summary.
2. Account snapshot (equity, cash, buying power, daytrade count).
3. Daily return and cumulative return since project start.
4. S&P 500 comparison. Bot vs S&P spread.
5. Trade decisions today (placed and skipped with exact rule-check reasons).
6. Stop-loss review (missing stops, moved floors, rejected stops, replacement stops).
7. Re-entry review (stopped-out names worth reconsidering).
8. What worked today.
9. What did not work today.
10. What to improve next session.
11. Tomorrow's watchlist and risk plan.
12. Confidence score 1–10 for tomorrow's plan with reasons.

Use python3 with reportlab or fpdf2 to generate the PDF programmatically.

### 8. Send EOD email with PDF
```bash
bash scripts/email-eod-pdf.sh "EOD Trading Report $DATE" "reports/daily/$DATE-eod-report.pdf"
```

### 9. Commit and push
```bash
git add memory/TRADE-LOG.md memory/RESEARCH-LOG.md reports/daily/$DATE-eod-report.pdf
git commit -m "EOD report $DATE"
git push origin main
```
