# TradeBot

TradeBot is a paper-trading research and operations toolkit built around Alpaca. It combines command-line account tools, Claude-assisted market research, documented trading routines, and persistent strategy and review logs.

## Capabilities

- Inspect account details, positions, orders, market quotes, price bars, and the market clock.
- Submit or cancel orders and close positions through Alpaca wrappers.
- Research market questions using the Anthropic API with web search.
- Organize pre-market, market-open, midday, daily-summary, and weekly-review workflows.
- Record catalysts, trades, risk checks, and performance reviews in Markdown.
- Send text updates or attach an existing PDF report using SMTP.

This repository supplies scripts and workflow definitions. Recurring scheduling and report generation require an external runner; cloning the repository does not start an autonomous service.

## Requirements

- Bash, curl, and Python 3.
- Alpaca paper-trading API credentials.
- An Anthropic API key for the research wrapper.
- SMTP credentials if email delivery is enabled.
- Claude Code if using the commands in `.claude/commands/`.

## Setup

```bash
cp env.template .env
# Edit .env with your credentials and your own email recipient.
set -a
source .env
set +a
bash scripts/alpaca.sh account
```

`set -a` exports the values for the Python subprocesses used by the research and email scripts. The template uses Alpaca's paper-trading endpoint. Keep `.env` private, and explicitly set `EMAIL_TO` because the template and email scripts contain a default recipient.

## Read-only commands

```bash
bash scripts/alpaca.sh account
bash scripts/alpaca.sh positions
bash scripts/alpaca.sh orders open
bash scripts/alpaca.sh quote AAPL
bash scripts/alpaca.sh clock
```

The wrapper also exposes order submission, cancellation, and position closing. Risk limits are documented in the workflow instructions; the shell wrapper does not independently enforce them.

## Workflow

| Routine | Intended time, Eastern Time | Purpose |
| --- | --- | --- |
| Pre-market | Weekdays around 8:30 AM | Research and a trading plan |
| Market open | Weekdays around 9:35 AM | Review and execute approved trades |
| Midday | Weekdays around 12:30 PM | Positions and stop review |
| Daily summary | Weekdays around 4:30 PM | End-of-day reporting |
| Weekly review | Friday around 5:00 PM | Strategy and performance review |

The corresponding command definitions and routines document position limits, stops, catalysts, and review requirements. Configure a scheduler separately if you want recurring execution.

## Repository layout

- `scripts/alpaca.sh`: Alpaca account, market-data, and order operations.
- `scripts/claude-research.sh`: Anthropic research requests; `CLAUDE_MODEL` can override the default model.
- `scripts/email.sh` and `scripts/email-eod-pdf.sh`: SMTP delivery and PDF attachment handling.
- `routines/`: scheduled workflow definitions.
- `.claude/commands/` and `CLAUDE.md`: command definitions and operating rules.
- `memory/`: strategy, project context, research, trades, and reviews.
- `reports/daily/`: report output directory.

If PDF email credentials are missing, the PDF email script records the report path in `EMAIL-FALLBACK.md`. Review logs and generated reports before committing: they can contain account and trading details.
