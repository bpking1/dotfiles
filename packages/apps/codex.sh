# name: OpenAI Codex CLI(官方安装脚本)
# scope: all

app_installed() { command -v codex >/dev/null; }
app_install() { curl -fsSL https://github.com/openai/codex/releases/latest/download/install.sh | CODEX_NON_INTERACTIVE=true sh; }
