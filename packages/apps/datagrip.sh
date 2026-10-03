# name: JetBrains Toolbox(用来装 DataGrip)
# scope: desktop

app_installed() { [ -x "$BIN/jetbrains-toolbox" ]; }
app_install() {
  local url tmp d
  url=$(curl -fsSL 'https://data.services.jetbrains.com/products/releases?code=TBA&latest=true&type=release' | jq -r '.TBA[0].downloads.linux.link')
  [ -n "$url" ] && [ "$url" != null ] || { echo "获取下载地址失败"; return 1; }
  tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  curl -fsSL "$url" | tar -xz -C "$tmp"
  d=$(echo "$tmp"/jetbrains-toolbox-*); rm -rf "$OPT/jetbrains-toolbox"; mv "$d" "$OPT/jetbrains-toolbox"
  ln -sfn "$OPT/jetbrains-toolbox/bin/jetbrains-toolbox" "$BIN/jetbrains-toolbox"
  echo "提示: 运行 jetbrains-toolbox 登录后在界面里安装 DataGrip"
}
