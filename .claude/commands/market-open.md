Run the market-open workflow. Purpose: execute only approved trades from today's pre-market research.

1. Resolve date: DATE=$(date +%Y-%m-%d)

2. Read:
   - memory/TRADING-STRATEGY.md
   - memory/RESEARCH-LOG.md (must have today's entry — if missing, run /pre-market first)
   - memory/TRADE-LOG.md

3. If today's research entry is missing in RESEARCH-LOG.md: stop. Run /pre-market first. Never trade without documented research.

4. Pull live state:
   bash scripts/alpaca.sh account
   bash scripts/alpaca.sh positions
   bash scripts/alpaca.sh orders
   bash scripts/alpaca.sh clock

5. For each trade idea from today's research, run the full buy-side gate:
   - Instrument is a stock.
   - Total positions after fill ≤ 6.
   - New trades this week ≤ 3.
   - Position cost ≤ 20% of equity.
   - Position cost ≤ available cash.
   - Daytrade count leaves room under PDT.
   - Specific catalyst documented in today's RESEARCH-LOG.md.
   - Sector momentum supports the trade.
   - Target provides ≥ 2:1 risk/reward.

6. Get fresh quote before each order:
   bash scripts/alpaca.sh quote TICKER

7. If approved, place market buy:
   bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"buy","type":"market","time_in_force":"day"}'

8. After fill, immediately place 10% trailing stop:
   bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"trailing_stop","trail_percent":"10","time_in_force":"gtc"}'

9. If trailing stop rejected (PDT), place fixed stop 10% below entry:
   bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"stop","stop_price":"X.XX","time_in_force":"gtc"}'

10. If fixed stop also rejected, log: "PDT-blocked stop. Must place stop tomorrow morning."

11. Append each trade to memory/TRADE-LOG.md.

12. If any trade executed:
    bash scripts/email.sh "Market Open Trade $DATE" "<ticker, shares, entry, stop, thesis>"

13. Commit and push if trades executed:
    git add memory/TRADE-LOG.md
    git commit -m "market-open trades $DATE"
    git push origin main
