Manual trade helper. Usage: /trade SYMBOL SHARES buy|sell

Parse SYMBOL, SHARES, and side from $ARGUMENTS.

## For BUY orders

1. Read memory/TRADING-STRATEGY.md, memory/TRADE-LOG.md, memory/RESEARCH-LOG.md.
2. Run full buy-side gate — all checks must pass:
   - Instrument is a stock (not ETF leveraged product, not options).
   - bash scripts/alpaca.sh positions → total open positions after fill ≤ 6.
   - New trades this week ≤ 3 (check TRADE-LOG.md).
   - Position cost (SHARES × current price) ≤ 20% of equity.
   - Position cost ≤ available cash.
   - Daytrade count leaves room under PDT.
   - Specific catalyst documented in today's RESEARCH-LOG.md entry.
   - Sector momentum supports the trade.
   - Target provides ≥ 2:1 risk/reward.
3. Get quote: bash scripts/alpaca.sh quote SYMBOL
4. Print the exact order JSON before placing.
5. Ask for confirmation. Do not place until confirmed.
6. Place order: bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"buy","type":"market","time_in_force":"day"}'
7. After fill confirmation, immediately place 10% trailing stop:
   bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"trailing_stop","trail_percent":"10","time_in_force":"gtc"}'
8. If trailing stop is rejected (PDT), place fixed stop 10% below entry:
   bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"stop","stop_price":"X.XX","time_in_force":"gtc"}'
9. If fixed stop also rejected, log: "PDT-blocked stop. Must place stop tomorrow morning."
10. Append to memory/TRADE-LOG.md.
11. bash scripts/email.sh "Trade $DATE" "BUY SYMBOL N shares @ $X | Stop: $X | Thesis: ..."

## For SELL orders

1. Confirm position exists: bash scripts/alpaca.sh positions
2. Cancel any open stop orders for this symbol: bash scripts/alpaca.sh orders → find and cancel.
3. Print order JSON before placing.
4. Ask for confirmation.
5. bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"market","time_in_force":"day"}'
6. Log exit to memory/TRADE-LOG.md with P&L.
7. bash scripts/email.sh "Trade $DATE" "SELL SYMBOL N shares @ $X | P&L: ..."

## If any buy gate check fails
- Do not trade.
- Log the skipped trade and failed rule to memory/TRADE-LOG.md.
- Print which check failed and why.
