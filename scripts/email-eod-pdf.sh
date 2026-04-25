#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FALLBACK="$ROOT/EMAIL-FALLBACK.md"

subject="${1:-}"
pdf_path="${2:-}"

if [[ -z "$subject" || -z "$pdf_path" ]]; then
  echo "usage: bash scripts/email-eod-pdf.sh \"<subject>\" \"<pdf-path>\"" >&2
  exit 1
fi

EMAIL_TO="${EMAIL_TO:-jm3nbot@gmail.com}"
stamp="$(date '+%Y-%m-%d %H:%M %Z')"

if [[ ! -f "$pdf_path" ]]; then
  echo "PDF not found: $pdf_path" >&2
  exit 2
fi

if [[ -z "${EMAIL_FROM:-}" || -z "${EMAIL_APP_PASSWORD:-}" || -z "${SMTP_HOST:-}" || -z "${SMTP_PORT:-}" ]]; then
  printf "\n---\n## %s\nSubject: %s\nTo: %s\nPDF ready: %s\n" "$stamp" "$subject" "$EMAIL_TO" "$pdf_path" >> "$FALLBACK"
  echo "[email fallback] PDF path appended to EMAIL-FALLBACK.md"
  exit 0
fi

EMAIL_SUBJECT="$subject" PDF_PATH="$pdf_path" python3 - <<'PY'
import os, smtplib
from email.message import EmailMessage
from pathlib import Path

pdf = Path(os.environ["PDF_PATH"])
msg = EmailMessage()
msg["Subject"] = os.environ["EMAIL_SUBJECT"]
msg["From"] = os.environ["EMAIL_FROM"]
msg["To"] = os.environ.get("EMAIL_TO", "jm3nbot@gmail.com")
msg.set_content("Daily trading report attached. Full analysis is in the PDF.")
msg.add_attachment(pdf.read_bytes(), maintype="application", subtype="pdf", filename=pdf.name)

host = os.environ["SMTP_HOST"]
port = int(os.environ["SMTP_PORT"])
password = os.environ["EMAIL_APP_PASSWORD"]

with smtplib.SMTP_SSL(host, port) as smtp:
    smtp.login(msg["From"], password)
    smtp.send_message(msg)

print(f"[email sent] {msg['Subject']} → {msg['To']} (PDF: {pdf.name})")
PY
