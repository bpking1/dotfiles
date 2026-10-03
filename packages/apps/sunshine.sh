# name: Sunshine 串流服务端
# scope: desktop

app_installed() { command -v sunshine >/dev/null; }
app_install() {
  if is_arch; then yay -S --needed --noconfirm sunshine; return; fi
  sudo dnf copr enable -y lizardbyte/stable    # 官方 COPR, 随 dnf upgrade 更新
  sudo dnf install -y Sunshine
}
