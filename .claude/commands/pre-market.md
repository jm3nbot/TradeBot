Run the pre-market research workflow. Purpose: create the day's research and trade plan before market open.

1. Resolve date: DATE=$(date +%Y-%m-%d)

2. Read in order:
   - memory/TRADING-STRATEGY.md
   - memory/TRADE-LOG.md
   - memory/RESEARCH-LOG.md
   - memory/PROJECT-CONTEXT.md

3. Pull live state:
   bash scripts/alpaca.sh account
   bash scripts/alpaca.sh positions
   bash scripts/alpaca.sh orders
   bash scripts/alpaca.sh clock

4. Run Claude market research:
   bash scripts/claude-research.sh "WTI and Brent oil price right now"
   bash scripts/claude-research.sh "S&P 500 futures premarket today"
   bash scripts/claude-research.sh "VIX level today"
   bash scripts/claude-research.sh "Top stock market catalysts today $DATE"
   bash scripts/claude-research.sh "Earnings reports before market open today $DATE"
   bash scripts/claude-research.sh "Economic calendar today CPI PPI FOMC jobs data $DATE"
   bash scripts/claude-research.sh "S&P 500 sector momentum today"

   Also research every currently held ticker:
   bash scripts/claude-research.sh "Latest news and price action for TICKER $DATE"

5. Identify 1–3 trade ideas that survive the buy-side gate. For each: ticker, catalyst, entry range, stop, target, R:R.

6. Append entry to memory/RESEARCH-LOG.md (use the standard format from that file).

7. Email only if urgent risk detected:
   bash scripts/email.sh "Pre-Market Alert $DATE" "<urgent summary>"

8. Commit and push:
   git add memory/RESEARCH-LOG.md
   git commit -m "pre-market research $DATE"
   git push origin main
