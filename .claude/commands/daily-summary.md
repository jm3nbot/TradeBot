Run the daily summary workflow. Purpose: preserve daily account state and send one EOD PDF after market close.

1. Resolve date: DATE=$(date +%Y-%m-%d)

2. Read:
   - memory/TRADE-LOG.md
   - memory/RESEARCH-LOG.md (today's entry)

3. Pull final state:
   bash scripts/alpaca.sh account
   bash scripts/alpaca.sh positions
   bash scripts/alpaca.sh orders

4. Research S&P 500 performance:
   bash scripts/claude-research.sh "S&P 500 daily performance for $DATE, closing performance, major drivers, and sector context"

5. Compute:
   - Day P&L in dollars and percent.
   - Phase P&L in dollars and percent (since project start).
   - S&P 500 daily return.
   - Bot return minus S&P 500 return.
   - Trades placed today.
   - Trades this week (vs. 3-trade limit).
   - Open positions count.
   - Stop status for every position.
   - Risk exposure by ticker and sector.

6. Append EOD snapshot to memory/TRADE-LOG.md:
   ### MMM DD EOD Snapshot
   **Portfolio:** $X | **Cash:** $X (X%) | **Day P&L:** ±$X (±X%) | **S&P 500:** ±X% | **Bot vs S&P:** ±X% | **Phase P&L:** ±$X (±X%)
   | Ticker | Shares | Entry | Close | Day Chg | Unrealized P&L | Stop | Risk Status |
   **Notes:** ...

7. Create PDF at reports/daily/$DATE-eod-report.pdf with all required sections:
   1. Executive summary.
   2. Account snapshot (equity, cash, buying power).
   3. Daily return and cumulative return.
   4. S&P 500 comparison and bot vs S&P spread.
   5. Trade decisions made today (placed and skipped with rule-check reasons).
   6. Stop-loss performance and current protection status.
   7. Re-entry review.
   8. Mistakes, weaknesses, risk concerns.
   9. What worked. What did not work.
   10. What to improve next session.
   11. Tomorrow's watchlist and risk plan.
   12. Confidence score 1–10 with reasons.

8. Send EOD email with PDF:
   bash scripts/email-eod-pdf.sh "EOD Trading Report $DATE" "reports/daily/$DATE-eod-report.pdf"

9. Commit and push:
   git add memory/TRADE-LOG.md memory/RESEARCH-LOG.md reports/daily/$DATE-eod-report.pdf
   git commit -m "EOD report $DATE"
   git push origin main
