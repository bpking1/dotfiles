# name: mise 开发工具链(go/rust/bun/dotnet/starship/yazi)
# scope: all

# 无 app_installed: 每次都执行, mise install 本身幂等; 增删工具改 private_dot_config/mise/config.toml
app_install() {
  local mise="$BIN/mise"
  [ -x "$mise" ] || { echo "安装 mise"; curl -fsSL https://mise.run | sh; }
  "$mise" install --yes
}
