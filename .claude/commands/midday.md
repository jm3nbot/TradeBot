Run the midday scan workflow. Purpose: manage open positions and enforce risk rules.

1. Resolve date: DATE=$(date +%Y-%m-%d)

2. Read:
   - memory/TRADING-STRATEGY.md
   - memory/TRADE-LOG.md
   - memory/RESEARCH-LOG.md (today's entry)

3. Pull current state:
   bash scripts/alpaca.sh positions
   bash scripts/alpaca.sh orders

4. For each open position, check unrealized P&L:
   - If unrealized loss ≥ –7%: close immediately.
     bash scripts/alpaca.sh close SYM
     Cancel any open stop orders for that symbol.
     Log exit to memory/TRADE-LOG.md.

5. Check stop tightening rules on winners:
   - Up ≥ 15%: cancel old stop, place 7% trailing stop.
   - Up ≥ 20%: cancel old stop, place 5% trailing stop.
   - Never tighten within 3% of current price.
   - Never move a stop down.
   - To replace stop: cancel old, then place new.
     bash scripts/alpaca.sh cancel <order_id>
     bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"trailing_stop","trail_percent":"X","time_in_force":"gtc"}'

6. Review thesis for each position. If price action is unexplained:
   bash scripts/claude-research.sh "Why is TICKER moving today $DATE"

7. Check sector rules: if 2 consecutive failed trades in a sector, flag it as a no-trade sector.

8. Append any exits, stop changes, or thesis updates to memory/TRADE-LOG.md.

9. Email only if action was taken:
   bash scripts/email.sh "Midday Action $DATE" "<action summary>"

10. Commit and push if memory changed:
    git add memory/TRADE-LOG.md
    git commit -m "midday scan $DATE"
    git push origin main
