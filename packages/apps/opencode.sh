# name: opencode CLI
# scope: all

app_installed() { command -v opencode >/dev/null || [ -x "$HOME/.opencode/bin/opencode" ]; }
app_install() { curl -fsSL https://opencode.ai/install | bash; }
