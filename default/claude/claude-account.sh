#!/usr/bin/env bash
# Start Claude Code with a specific account, bound into the sandbox as
# claude-default, claude-subscription-02 and claude-<name> (one per ~/.claude-<name>).
# The account is taken from the name this file is invoked as, so it works the
# same in any pane, tab or shell regardless of the session's picker choice.
#   claude-subscription-02 [claude args...]      -> CLAUDE_CONFIG_DIR=~/.claude-subscription-02
#   claude-default [claude args...]  -> CLAUDE_CONFIG_DIR=~/.claude

set -euo pipefail

account="$(basename "$0")"
account="${account#claude-}"

case "$account" in
  default) dir="$HOME/.claude" ;;
  *[!a-z0-9_-]* | "" | shared) echo "claude-account: invalid account '$account'" >&2; exit 1 ;;
  *) dir="$HOME/.claude-$account" ;;
esac

if [ ! -d "$dir" ]; then
  echo "claude-account: $dir does not exist (start the sandbox with --claude-account $account first)." >&2
  exit 1
fi

export CLAUDE_CONFIG_DIR="$dir"
if [ ! -s "$dir/.credentials.json" ]; then
  echo "claude-$account: not logged in yet; run /login after Claude starts." >&2
fi
exec claude "$@"
