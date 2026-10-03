# name: Neovide 图形界面 Neovim
# scope: desktop

app_installed() { command -v neovide >/dev/null; }
app_install() {
  if is_arch; then yay -S --needed --noconfirm neovide; return; fi
  local tag tmp; tag=$(gh_tag neovide/neovide); tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  curl -fSL --progress-bar "https://github.com/neovide/neovide/releases/download/${tag}/neovide-linux-x86_64.tar" | tar -x -C "$tmp"
  install -m755 "$tmp/neovide" "$BIN/neovide"
}
