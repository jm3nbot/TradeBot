# Project Context

## Account
- Broker: Alpaca
- Mode: Paper trading (testing)
- Endpoint: https://paper-api.alpaca.markets/v2
- Data endpoint: https://data.alpaca.markets

## Project Start
- Date: 2026-04-26
- Starting equity: TBD (run `bash scripts/alpaca.sh account` to confirm)

## Benchmark
- Target: Beat S&P 500 over the challenge window.
- Track daily bot return vs. S&P 500 daily return in every EOD report.

## Notification Recipient
- Email: jm3nbot@gmail.com

## Routine Schedule (cloud)
- Pre-market: ~8:30 AM ET weekdays
- Market open: ~9:35 AM ET weekdays
- Midday scan: ~12:30 PM ET weekdays
- Daily summary: ~4:30 PM ET weekdays
- Weekly review: Friday ~5:00 PM ET

## Key Constraints
- PDT rule applies if account < $25,000.
- Same-day stops after same-day buys may be rejected — use fallback ladder.
- Alpaca trailing stops do not protect against overnight gaps.
- Alpaca timestamps are UTC.

## Notes
- Cloud routine containers are ephemeral — always commit and push memory changes.
- Never force-push.
- Market research goes through claude-research.sh, not Perplexity.
