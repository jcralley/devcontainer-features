#!/usr/bin/env bash
# Bootstrap zskills into the current workspace.
# Call from postCreateCommand / setup.sh after the workspace is mounted.
set -euo pipefail

ZSKILLS_SRC="/usr/local/share/ai-dev-tools/zskills"
WORKSPACE="${1:-$(pwd)}"

echo "🔧 Bootstrapping zskills into workspace..."

mkdir -p "${WORKSPACE}/.claude/skills" "${WORKSPACE}/.claude/hooks"
cp -r "${ZSKILLS_SRC}/skills/." "${WORKSPACE}/.claude/skills/"
cp -r "${ZSKILLS_SRC}/hooks/." "${WORKSPACE}/.claude/hooks/"

mkdir -p "${WORKSPACE}/scripts"
cp -r "${ZSKILLS_SRC}/scripts/." "${WORKSPACE}/scripts/"

cp "${ZSKILLS_SRC}/zskills-config.schema.json" "${WORKSPACE}/.claude/zskills-config.schema.json"

if [ ! -f "${WORKSPACE}/.claude/zskills-config.json" ]; then
  echo "📝 No zskills-config.json found — copying default config..."
  cp "${ZSKILLS_SRC}/zskills-config.json" "${WORKSPACE}/.claude/zskills-config.json"
fi

echo "✅ zskills bootstrapped."
