# Routines

These markdown files define the scheduled workflows for the trading bot.

Each routine is designed to be executed by a Claude agent in a cloud environment (e.g., via a cron schedule or remote trigger).

## Routines

| File | Purpose | Schedule |
|------|---------|----------|
| pre-market.md | Market research and trade plan | ~8:30 AM ET weekdays |
| market-open.md | Execute approved trades | ~9:35 AM ET weekdays |
| midday.md | Risk management and stop review | ~12:30 PM ET weekdays |
| daily-summary.md | EOD PDF report and account snapshot | ~4:30 PM ET weekdays |
| weekly-review.md | Weekly performance review | Friday ~5:00 PM ET |

## Environment Requirements

All routines require these environment variables:

```
ALPACA_API_KEY
ALPACA_SECRET_KEY
ALPACA_ENDPOINT
ALPACA_DATA_ENDPOINT
CLAUDE_API_KEY
EMAIL_TO
EMAIL_FROM
EMAIL_APP_PASSWORD
SMTP_HOST
SMTP_PORT
```

## Persistence

Cloud containers are ephemeral. Each routine that modifies memory files must commit and push at the end.

## Failure Handling

If any routine fails mid-run:
1. Stop new trading actions.
2. Pull live Alpaca state to reconcile.
3. Log discrepancy.
4. Send self-email alert if email credentials are available.
5. Commit memory if anything changed.
