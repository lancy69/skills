#!/bin/sh

set -euo pipefail

ledger="${XDG_DATA_HOME:-$HOME/.local/share}/TODO.md"

if [ ! -e "$ledger" ]; then
  printf 'list-ideas.sh: ledger not exists: %s\n' "$ledger" >&2
  exit 1
fi

if [ ! -f "$ledger" ]; then
  printf 'list-ideas.sh: ledger is not a regular file: %s\n' "$ledger" >&2
  exit 1
fi

if [ ! -r "$ledger" ]; then
  printf 'list-ideas.sh: ledger is not readable: %s\n' "$ledger" >&2
  exit 1
fi

grep "^# " "$ledger" | sed "s/^# //"
