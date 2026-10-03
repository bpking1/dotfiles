# name: Waydroid 安卓容器
# scope: desktop

app_installed() { command -v waydroid >/dev/null; }
app_install() {
  if is_arch; then yay -S --needed --noconfirm waydroid; else sudo dnf install -y waydroid; fi
  echo "提示: 首次使用需 sudo waydroid init"
}
