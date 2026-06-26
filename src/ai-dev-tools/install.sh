#!/usr/bin/env bash
set -euo pipefail

REMOTE_USER="${_REMOTE_USER:-vscode}"
REMOTE_USER_HOME="${_REMOTE_USER_HOME:-/home/${REMOTE_USER}}"
ZSH_CUSTOM="${REMOTE_USER_HOME}/.oh-my-zsh/custom"

# Update npm to latest
echo "🔄 Updating npm..."
npm install -g npm@latest

# Install AI CLIs
echo "🤖 Installing Claude Code..."
npm install -g @anthropic-ai/claude-code@latest

echo "✨ Installing Gemini CLI..."
npm install -g @google/gemini-cli@latest

echo "🧠 Installing OpenAI Codex..."
npm install -g @openai/codex@latest

# Remove stale Yarn APT repo (missing GPG key breaks apt-get update)
rm -f /etc/apt/sources.list.d/yarn.list

# Install Playwright + Chromium
if [ "${INSTALLPLAYWRIGHT}" = "true" ]; then
  echo "🎭 Installing Playwright + Chromium..."
  npx -y playwright@latest install --with-deps chromium || \
    npx -y playwright@latest install chromium
fi

# Install Powerlevel10k zsh theme
echo "🎨 Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  "${ZSH_CUSTOM}/themes/powerlevel10k"
chown -R "${REMOTE_USER}:${REMOTE_USER}" "${ZSH_CUSTOM}/themes/powerlevel10k"

# Set theme in .zshrc
if [ -f "${REMOTE_USER_HOME}/.zshrc" ]; then
  sed -i '/^ZSH_THEME=/s/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' \
    "${REMOTE_USER_HOME}/.zshrc"
fi

# Copy p10k config
cp "$(dirname "$0")/p10k.zsh" "${REMOTE_USER_HOME}/.p10k.zsh"
chown "${REMOTE_USER}:${REMOTE_USER}" "${REMOTE_USER_HOME}/.p10k.zsh"

# Source p10k config from .zshrc
if ! grep -q 'p10k.zsh' "${REMOTE_USER_HOME}/.zshrc" 2>/dev/null; then
  echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> "${REMOTE_USER_HOME}/.zshrc"
fi

# Install zskills bundle to a known location
echo "🛠️  Installing zskills bundle..."
ZSKILLS_DEST="/usr/local/share/ai-dev-tools/zskills"
mkdir -p "${ZSKILLS_DEST}"
cp -r "$(dirname "$0")/zskills/." "${ZSKILLS_DEST}/"

# Install the workspace bootstrap script
install -m 0755 "$(dirname "$0")/bootstrap-workspace.sh" \
  /usr/local/bin/ai-dev-tools-bootstrap-workspace

echo "✅ AI dev tools installed."
