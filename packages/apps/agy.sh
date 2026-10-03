# name: Antigravity CLI (agy, 官方安装脚本)
# scope: all

app_installed() { command -v agy >/dev/null; }
app_install() { curl -fsSL https://antigravity.google/cli/install.sh | bash; }
