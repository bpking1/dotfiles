# name: Overskride 蓝牙管理(waybar 引用)
# scope: desktop

# Arch: AUR 预编译包; Fedora: 官方 release 的预编译包(二进制硬编码读取 /usr/share/overskride, 故装到系统目录)
app_installed() { command -v overskride >/dev/null; }
app_install() {
  if is_arch; then yay -S --needed --noconfirm overskride-bin; return; fi
  [ "$(uname -m)" = x86_64 ] || { echo "未适配架构: $(uname -m)"; return 1; }
  local tag tmp; tag=$(gh_tag kaii-lb/overskride); tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  sudo dnf install -y gtk4 libadwaita bluez
  curl -fsSL "https://github.com/kaii-lb/overskride/releases/download/${tag}/overskride.tar.xz" | tar -xJ -C "$tmp"
  sudo install -Dm755 "$tmp/package/usr/bin/overskride" /usr/local/bin/overskride
  sudo cp -r "$tmp/package/usr/share/." /usr/share/
  sudo glib-compile-schemas /usr/share/glib-2.0/schemas
  sudo gtk-update-icon-cache -q /usr/share/icons/hicolor 2>/dev/null || true
}
