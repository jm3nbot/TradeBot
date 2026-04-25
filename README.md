# TradeBot

Autonomous AI trading agent built on Claude + Alpaca. Goal: beat S&P 500 while protecting capital through strict risk rules.

## Quick Start

```bash
cp env.template .env
# fill in .env with your keys

source .env
bash scripts/alpaca.sh account
```

## Daily Workflow

| Command | When | What |
|---------|------|------|
| `/pre-market` | ~8:30 AM ET | Market research + trade plan |
| `/market-open` | ~9:35 AM ET | Execute approved trades |
| `/midday` | ~12:30 PM ET | Risk management + stop review |
| `/daily-summary` | ~4:30 PM ET | EOD PDF report |
| `/weekly-review` | Friday ~5 PM ET | Weekly performance review |

Ad-hoc:
- `/portfolio` — read-only account snapshot
- `/trade SYMBOL SHARES buy|sell` — manual trade with full gate check

## Structure

```
├── CLAUDE.md              # Agent instructions and rules
├── .claude/commands/      # Claude Code slash commands
├── routines/              # Scheduled workflow definitions
├── scripts/               # Shell wrappers (alpaca, email, research)
├── memory/                # Persistent state (committed to git)
│   ├── TRADING-STRATEGY.md
│   ├── TRADE-LOG.md
│   ├── RESEARCH-LOG.md
│   ├── WEEKLY-REVIEW.md
│   └── PROJECT-CONTEXT.md
└── reports/daily/         # EOD PDF reports
```

## Rules (non-negotiable)

- Stocks only. No options.
- Max 5–6 positions, max 3 new trades/week.
- Max 20% of equity per position.
- Every position gets a GTC trailing stop immediately after fill.
- Hard cut at –7% unrealized loss.
- No trade without a documented catalyst.

See `CLAUDE.md` for the full rule set.
