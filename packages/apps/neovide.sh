# name: Neovide 图形界面 Neovim
# scope: desktop

app_installed() { command -v neovide >/dev/null && [ -f "$HOME/.local/share/applications/neovide.desktop" ]; }
app_install() {
  if is_arch; then yay -S --needed --noconfirm neovide; desktop_entry neovide Neovide "neovide %F" "" "Utility;TextEditor;Development;"; return; fi
  local tag tmp; tag=$(gh_tag neovide/neovide); tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  curl -fSL --progress-bar "https://github.com/neovide/neovide/releases/download/${tag}/neovide-linux-x86_64.tar" | tar -x -C "$tmp"
  install -m755 "$tmp/neovide" "$BIN/neovide"
  desktop_entry neovide Neovide "$BIN/neovide %F" https://raw.githubusercontent.com/neovide/neovide/main/assets/neovide.svg "Utility;TextEditor;Development;"
}
