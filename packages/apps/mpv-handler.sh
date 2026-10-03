# name: mpv-handler(mpv:// 协议)
# scope: desktop

# 协议注册依赖 chezmoi 部署的 ~/.local/share/applications/mpv-handler.desktop
PIN=""   # 例: "v0.4.2"; 空 = 最新

app_installed() { [ -z "$PIN" ] && command -v mpv-handler >/dev/null; }
app_install() {
  local tag tmp bin; tag="${PIN:-$(gh_tag akiirui/mpv-handler)}"
  tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  curl -fSL --progress-bar "https://github.com/akiirui/mpv-handler/releases/download/${tag}/mpv-handler-linux-amd64.zip" -o "$tmp/h.zip"
  unzip -qo "$tmp/h.zip" -d "$tmp"
  bin=$(find "$tmp" -type f -name mpv-handler | head -1)
  [ -n "$bin" ] || { echo "解包后未找到二进制"; return 1; }
  sudo install -m755 "$bin" /usr/local/bin/mpv-handler
  if [ -f "$HOME/.local/share/applications/mpv-handler.desktop" ]; then
    # v0.4.0 起协议由 mpv:// 改名为 mpv-handler://
    xdg-mime default mpv-handler.desktop x-scheme-handler/mpv-handler
    xdg-mime default mpv-handler-debug.desktop x-scheme-handler/mpv-handler-debug
    update-desktop-database "$HOME/.local/share/applications/" && echo "mpv-handler:// 协议已注册"
  else
    echo "!! desktop 文件缺失(chezmoi 应已部署),协议未注册"
  fi
}
