#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FALLBACK="$ROOT/EMAIL-FALLBACK.md"

subject="${1:-}"
body="${2:-}"

if [[ -z "$subject" || -z "$body" ]]; then
  echo "usage: bash scripts/email.sh \"<subject>\" \"<message>\"" >&2
  exit 1
fi

EMAIL_TO="${EMAIL_TO:-jm3nbot@gmail.com}"
stamp="$(date '+%Y-%m-%d %H:%M %Z')"

if [[ -z "${EMAIL_FROM:-}" || -z "${EMAIL_APP_PASSWORD:-}" || -z "${SMTP_HOST:-}" || -z "${SMTP_PORT:-}" ]]; then
  printf "\n---\n## %s\nSubject: %s\nTo: %s\n\n%s\n" "$stamp" "$subject" "$EMAIL_TO" "$body" >> "$FALLBACK"
  echo "[email fallback] appended to EMAIL-FALLBACK.md"
  exit 0
fi

EMAIL_SUBJECT="$subject" EMAIL_BODY="$body" python3 - <<'PY'
import os, smtplib
from email.message import EmailMessage

msg = EmailMessage()
msg["Subject"] = os.environ["EMAIL_SUBJECT"]
msg["From"] = os.environ["EMAIL_FROM"]
msg["To"] = os.environ.get("EMAIL_TO", "jm3nbot@gmail.com")
msg.set_content(os.environ["EMAIL_BODY"])

host = os.environ["SMTP_HOST"]
port = int(os.environ["SMTP_PORT"])
password = os.environ["EMAIL_APP_PASSWORD"]

with smtplib.SMTP_SSL(host, port) as smtp:
    smtp.login(msg["From"], password)
    smtp.send_message(msg)

print(f"[email sent] {msg['Subject']} → {msg['To']}")
PY
