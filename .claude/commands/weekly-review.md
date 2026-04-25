Run the weekly review workflow. Purpose: review performance and improve strategy only when evidence supports it. Runs Friday after close.

1. Resolve date: DATE=$(date +%Y-%m-%d)

2. Read:
   - memory/WEEKLY-REVIEW.md
   - memory/TRADE-LOG.md
   - memory/RESEARCH-LOG.md
   - memory/TRADING-STRATEGY.md

3. Pull account and positions:
   bash scripts/alpaca.sh account
   bash scripts/alpaca.sh positions

4. Research S&P 500 weekly performance:
   bash scripts/claude-research.sh "S&P 500 weekly performance week ending $DATE"

5. Compute:
   - Starting portfolio (from last week's snapshot).
   - Ending portfolio.
   - Week return in dollars and percent.
   - S&P 500 week return.
   - Bot vs S&P spread.
   - Total trades taken this week (W:X / L:Y / open:Z).
   - Win rate.
   - Best trade.
   - Worst trade.
   - Profit factor (gross wins / gross losses).

6. Append to memory/WEEKLY-REVIEW.md using the standard format.

7. Update memory/TRADING-STRATEGY.md ONLY if a rule has proven itself for ≥2 weeks OR failed badly. Do not change strategy on a whim.

8. Include weekly review inside the EOD PDF (do not send a separate email).

9. Commit and push:
   git add memory/WEEKLY-REVIEW.md memory/TRADING-STRATEGY.md
   git commit -m "weekly review $DATE"
   git push origin main

   If strategy did not change:
   git add memory/WEEKLY-REVIEW.md
   git commit -m "weekly review $DATE"
   git push origin main
