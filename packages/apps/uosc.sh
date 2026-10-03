# name: uosc(mpv 现代化 UI, GitHub release)
# scope: desktop

PIN=""   # 例: "5.13.0"; 空 = 最新

app_installed() {
  local want; want="${PIN:-$(gh_tag tomasklaen/uosc)}"
  grep -q "uosc_version = '$want'" "$HOME/.config/mpv/scripts/uosc/main.lua" 2>/dev/null
}
app_install() {
  local tag tmp; tag="${PIN:-$(gh_tag tomasklaen/uosc)}"; tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  curl -fSL --progress-bar "https://github.com/tomasklaen/uosc/releases/download/${tag}/uosc.zip" -o "$tmp/uosc.zip" || { echo "下载失败"; return 1; }
  unzip -qo "$tmp/uosc.zip" -d "$tmp/x" || { echo "解压失败"; return 1; }
  [ -d "$tmp/x/scripts/uosc" ] || { echo "release 包结构异常"; return 1; }
  rm -rf "$HOME/.config/mpv/scripts/uosc"
  mkdir -p "$HOME/.config/mpv/scripts" "$HOME/.config/mpv/fonts"
  cp -r "$tmp/x/scripts/uosc" "$HOME/.config/mpv/scripts/uosc"
  cp "$tmp/x/fonts/"uosc_icons.otf "$tmp/x/fonts/"uosc_textures.ttf "$HOME/.config/mpv/fonts/"
}
