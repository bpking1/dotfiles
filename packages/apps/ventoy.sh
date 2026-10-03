# name: Ventoy 启动盘制作
# scope: desktop

app_installed() { [ -x "$BIN/ventoy-gui" ] && [ -f "$HOME/.local/share/applications/ventoy.desktop" ]; }
app_install() {
  local tag ver tmp; tag=$(gh_tag ventoy/Ventoy); ver="${tag#v}"; tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  curl -fSL --progress-bar "https://github.com/ventoy/Ventoy/releases/download/${tag}/ventoy-${ver}-linux.tar.gz" | tar -xz -C "$tmp"
  rm -rf "$OPT/ventoy-${ver}"; mv "$tmp/ventoy-${ver}" "$OPT/ventoy-${ver}"
  ln -sfn "$OPT/ventoy-${ver}" "$OPT/ventoy"
  ln -sfn "$OPT/ventoy/VentoyGUI.x86_64" "$BIN/ventoy-gui"
  desktop_entry ventoy Ventoy "$BIN/ventoy-gui" "" "System;"
  echo "启动: ventoy-gui (写盘需要 root)"
}
