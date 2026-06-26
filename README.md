# devcontainer-features

Personal Dev Container features for reuse across projects.

## Features

### `ai-dev-tools`

Installs:
- [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) (`@anthropic-ai/claude-code`)
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) (`@google/gemini-cli`)
- [OpenAI Codex CLI](https://github.com/openai/codex) (`@openai/codex`)
- [Playwright + Chromium](https://playwright.dev/) (headless, for e2e testing and MCP)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) zsh theme with bundled config

**Usage in `devcontainer.json`:**

```json
{
  "features": {
    "ghcr.io/jcralley/devcontainer-features/ai-dev-tools:1": {}
  }
}
```

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `installPlaywright` | boolean | `true` | Install Playwright and Chromium |

**Project-specific setup** (MCP registration, env vars) goes in the project's `postCreateCommand`.
