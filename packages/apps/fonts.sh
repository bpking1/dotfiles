# name: 字体(FiraCode Nerd Font + 霞鹜文楷)
# scope: desktop

# 只装配置实际用到的字重: FiraCode Mono Regular/Bold(kitty+fontconfig), 文楷 Regular/Medium(无 Bold, 粗体由 Medium 承接)
FONT_DIR="$HOME/.local/share/fonts"
NF_PIN=""      # nerd-fonts tag, 例 "v3.5.1"; 空 = 最新
LXGW_PIN=""    # LxgwWenKai tag, 例 "v1.522"; 空 = 最新

app_installed() {
  [ -z "$NF_PIN$LXGW_PIN" ] && [ -f "$FONT_DIR/FiraCode/FiraCodeNerdFontMono-Regular.ttf" ] \
    && [ -f "$FONT_DIR/lxgw/LXGWWenKai-Regular.ttf" ] && [ -f "$FONT_DIR/lxgw/LXGWWenKai-Medium.ttf" ]
}
app_install() {
  local tag tmp; tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  tag="${NF_PIN:-$(gh_tag ryanoasis/nerd-fonts)}"
  echo "FiraCode Nerd Font ($tag)"
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/${tag}/FiraCode.zip" -o "$tmp/fira.zip"
  mkdir -p "$FONT_DIR/FiraCode"
  unzip -qoj "$tmp/fira.zip" FiraCodeNerdFontMono-Regular.ttf FiraCodeNerdFontMono-Bold.ttf -d "$FONT_DIR/FiraCode"
  tag="${LXGW_PIN:-$(gh_tag lxgw/LxgwWenKai)}"
  echo "霞鹜文楷 Regular/Medium ($tag)"
  mkdir -p "$FONT_DIR/lxgw"
  for w in Regular Medium; do
    curl -fsSL "https://github.com/lxgw/LxgwWenKai/releases/download/${tag}/LXGWWenKai-${w}.ttf" -o "$FONT_DIR/lxgw/LXGWWenKai-${w}.ttf"
  done
  fc-cache -f "$FONT_DIR"
}
