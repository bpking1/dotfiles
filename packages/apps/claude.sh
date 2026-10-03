# name: Claude Code CLI
# scope: all

app_installed() { command -v claude >/dev/null || [ -x "$BIN/claude" ]; }
app_install() { curl -fsSL https://claude.ai/install.sh | bash; }
