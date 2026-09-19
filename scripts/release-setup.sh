#!/usr/bin/env bash
# Give a repo what it needs to publish here, without typing the token again.
#
# Organisation secrets would do this once for everything, but GitHub reserves
# those for paid plans when the repository is private. So the token lives in
# the Keychain instead -- entered once, on this machine -- and this copies it
# into each new project as it is created.
#
#   ./scripts/release-setup.sh store                     # once, ever
#   ./scripts/release-setup.sh mabdurrafey1/foo  # once per project
#
# The value is piped straight from the Keychain to GitHub. It is never
# printed, never written to a file, and never reaches your shell history.

set -euo pipefail

ACCOUNT="github-releases-token"
SERVICE="client-releases"
SECRET="RELEASES_TOKEN"

usage() {
  echo "usage: $0 store | $0 <owner/repo> [owner/repo ...]" >&2
  exit 64
}

[ $# -ge 1 ] || usage

if [ "$1" = "store" ]; then
  # -U updates in place if it is already there, rather than refusing.
  security add-generic-password -U -a "$ACCOUNT" -s "$SERVICE" -w
  echo "stored. now: $0 <owner/repo>"
  exit 0
fi

token=$(security find-generic-password -a "$ACCOUNT" -s "$SERVICE" -w 2>/dev/null) || {
  echo "no token in the Keychain yet -- run: $0 store" >&2
  exit 1
}

for repo in "$@"; do
  printf '%s' "$token" | gh secret set "$SECRET" --repo "$repo" --body -
  echo "$repo can publish"
done
