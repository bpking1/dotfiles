# name: pot 划词翻译(AppImage)
# scope: desktop
# distro: fedora
# 官方 rpm 的依赖写的是 Debian 包名(libwebkit2gtk-4.0 等), Fedora 装不上, 改用 AppImage; Arch 侧在 arch.txt 声明 pot-translation
PIN=""   # 例: "3.0.7"; 空 = 最新
app_installed() { [ -z "$PIN" ] && [ -x "$BIN/pot" ] && [ -f "$HOME/.local/share/applications/pot.desktop" ]; }
app_install() {
  local ver; ver="${PIN:-$(gh_tag pot-app/pot-desktop)}"
  [ "$(uname -m)" = x86_64 ] || { echo "未适配架构: $(uname -m)"; return 1; }
  mkdir -p "$OPT/pot" "$BIN"
  curl -fSL --progress-bar "https://github.com/pot-app/pot-desktop/releases/download/${ver}/pot_${ver}_amd64.AppImage" -o "$OPT/pot/pot.AppImage"
  chmod +x "$OPT/pot/pot.AppImage"
  # 包装脚本: 免 fuse 运行, 命令名 pot 供 hypr 自启/快捷键使用
  printf '#!/bin/sh\nAPPIMAGE_EXTRACT_AND_RUN=1 exec "%s/pot/pot.AppImage" "$@"\n' "$OPT" > "$BIN/pot"; chmod +x "$BIN/pot"
  desktop_entry pot "Pot 翻译" "$BIN/pot" https://raw.githubusercontent.com/pot-app/pot-desktop/master/src-tauri/icons/128x128.png "Utility;"
}
