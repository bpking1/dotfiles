# name: pot 划词翻译(GitHub rpm)
# scope: desktop
# distro: fedora

# Fedora 官方仓无此包; Arch 侧在 arch.txt 声明 pot-translation
PIN=""   # 例: "3.0.7"; 空 = 最新

app_installed() { [ -z "$PIN" ] && rpm -q pot &>/dev/null; }
app_install() {
  local ver tmp; ver="${PIN:-$(gh_tag pot-app/pot-desktop)}"
  [ "$(uname -m)" = x86_64 ] || { echo "未适配架构: $(uname -m)"; return 1; }
  tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  curl -fsSL "https://github.com/pot-app/pot-desktop/releases/download/${ver}/pot-${ver}-1.x86_64.rpm" -o "$tmp/pot.rpm"
  sudo dnf install -y "$tmp/pot.rpm"
}
