# name: ffmpeg + ffprobe(Fedora: BtbN 静态构建; Arch: 官方包)
# scope: all

# Fedora 官方仓只有 ffmpeg-free(缺部分编码器), rpmfusion 版会与之冲突, 故用静态构建装到用户目录
FF_DIR="$HOME/.local/share/ffmpeg"

app_installed() { command -v ffmpeg >/dev/null && command -v ffprobe >/dev/null; }
app_install() {
  if is_arch; then yay -S --needed --noconfirm ffmpeg; return; fi
  [ "$(uname -m)" = x86_64 ] || { echo "未适配架构: $(uname -m)"; return 1; }
  local asset tmp dir
  # BtbN 滚动发布 latest: 取版本号最大的稳定分支构建(排除 master)
  asset=$(curl -fsSL https://api.github.com/repos/BtbN/FFmpeg-Builds/releases/latest \
    | jq -r '[.assets[].name | select(test("^ffmpeg-n[0-9.]+-latest-linux64-gpl-[0-9.]+\\.tar\\.xz$"))]
             | sort_by(capture("n(?<v>[0-9.]+)-latest").v | split(".") | map(tonumber)) | last')
  [ -n "$asset" ] && [ "$asset" != null ] || { echo "未找到 ffmpeg 构建资源(GitHub API 限流?)"; return 1; }
  tmp=$(mktemp -d); trap 'rm -rf "$tmp"' RETURN
  echo "下载 $asset"
  curl -fsSL "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/$asset" | tar -xJ -C "$tmp"
  dir=$(basename "$(echo "$tmp"/ffmpeg-*)")
  mkdir -p "$FF_DIR"; rm -rf "$FF_DIR/$dir"; mv "$tmp/$dir" "$FF_DIR/$dir"
  ln -sfn "$FF_DIR/$dir/bin/ffmpeg" "$BIN/ffmpeg"
  ln -sfn "$FF_DIR/$dir/bin/ffprobe" "$BIN/ffprobe"
}
