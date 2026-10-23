#!/usr/bin/env bash
set -eo pipefail

# Serialize builds on the shared Droplet.
exec 9>"$HOME/code/deploy/.node-deploy.lock"
flock 9

APP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
cd "$APP_DIR"
nvm install "$(cat .nvmrc)"
nvm use
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

pnpm install --frozen-lockfile
pnpm run build
rsync -a --delete dist/ /var/www/bulkheaders/
