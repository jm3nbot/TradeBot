# Trading Strategy

## Goal
Beat the S&P 500 over the challenge window while protecting capital.

## Identity
- Aggressive but disciplined.
- Stocks only. No options, ever.
- No trade without a catalyst documented in RESEARCH-LOG.md.

## Position Rules
- Max 5–6 open positions at one time.
- Max 20% of account equity per position.
- Target 75–85% of capital deployed when strong setups exist.

## Trade Frequency
- Max 3 new trades per week.
- A no-trade day is valid if no setup passes the gate.

## Stop Rules
- Every new position gets a GTC trailing stop on Alpaca immediately after fill.
- Default stop: 10% trailing stop.
- Hard cut at –7% from entry regardless of stop.
- Tighten to 7% trailing when position is up ≥15%.
- Tighten to 5% trailing when position is up ≥20%.
- Never tighten a stop within 3% of current price.
- Never move a stop down.
- Always cancel old stop before placing replacement.

## Sector Rules
- Follow sector momentum.
- Exit a sector after 2 consecutive failed trades in that sector.

## Buy Gate (all must pass)
1. Instrument is a stock.
2. Total positions after fill ≤ 6.
3. New trades this week ≤ 3.
4. Position cost ≤ 20% of equity.
5. Position cost ≤ available cash.
6. Daytrade count leaves room under PDT.
7. Specific catalyst documented in today's RESEARCH-LOG.md.
8. Sector momentum supports the trade.
9. Target provides ≥ 2:1 risk/reward.

## Sell Triggers (immediate)
- Unrealized loss ≥ –7%.
- Thesis broken.
- Catalyst invalidated.
- Sector rolls over sharply.
- 2 consecutive failed trades in same sector.

## US Tax Rules (account holder is US-tax-resident, based in UAE)

- **Wash sale rule**: Do not repurchase the same ticker (or a substantially identical security) within 30 days before or after selling it at a loss. Wash sale losses are disallowed and add to the cost basis of the replacement position. Flag any potential wash sale in TRADE-LOG.md before placing the buy order.
- **Short-term gains**: Positions held < 1 year taxed as ordinary income. Prefer setups with multi-week hold potential when equivalent risk/reward exists.
- **Long-term gains**: Positions held ≥ 1 year taxed at 0/15/20% preferential rate. Do not hold losers to chase long-term status — the –7% hard cut rule overrides all tax considerations.
- **No UAE capital gains tax** applies; US federal (and state, if applicable) tax rules govern.

## Strategy Version History
| Date | Change | Reason |
|------|--------|--------|
| 2026-04-26 | Initial strategy document | Project start |
| 2026-04-26 | Added US tax rules section | Account holder is US-tax-resident based in UAE |
