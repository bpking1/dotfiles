# 应用安装公共库 — 被菜单脚本(run_once_before_10)和安装驱动(run_onchange_after_20)共用
# 应用文件规范(packages/apps/<id>.sh, 放进目录即自动出现在勾选菜单):
#   头部元数据(注释, 每行一项):
#     # name: 显示名            (必填)
#     # scope: desktop | all    (必填; desktop = 仅桌面模式)
#     # distro: fedora | arch   (可选; 限定发行版家族)
#   函数:
#     app_install    (必填) 安装; 失败返回非 0
#     app_installed  (可选) 已安装则返回 0, 驱动会跳过; 省略则每次都执行 app_install(需自身幂等)
#   可用辅助: is_arch / gh_tag / flatpak_app / $BIN / $OPT

OPT="$HOME/.local/opt"; BIN="$HOME/.local/bin"
SEL_FILE="$HOME/.config/chezmoi/selection"

distro_family() {
  case "$OS_ID" in
    fedora) echo fedora ;;
    arch|cachyos|endeavouros|manjaro) echo arch ;;
    *) echo "$OS_ID" ;;
  esac
}
is_arch() { [ "$(distro_family)" = arch ]; }

# 读取头部元数据: app_meta 文件 键
app_meta() { sed -n "s/^# $2: *//p" "$1" | head -1; }

# 当前模式/发行版是否适用: app_applicable 文件   (需要 $IS_DESKTOP 与 $OS_ID)
app_applicable() {
  local scope distro
  scope=$(app_meta "$1" scope); distro=$(app_meta "$1" distro)
  [ "$scope" = desktop ] && [ "$IS_DESKTOP" != 1 ] && return 1
  [ -n "$distro" ] && [ "$distro" != "$(distro_family)" ] && return 1
  return 0
}

# 是否被勾选(选择文件里以 - 开头的为取消; 无文件 = 全选)
selected() { ! grep -qx -- "-$1" "$SEL_FILE" 2>/dev/null; }

gh_tag() {   # GitHub 最新 release 的 tag
  local t; t=$(curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r .tag_name)
  [ -n "$t" ] && [ "$t" != null ] || { echo "版本获取失败(GitHub API 限流?)" >&2; return 1; }
  echo "$t"
}

flatpak_app() {   # $1 = Flathub 应用 ID
  command -v flatpak >/dev/null || { echo "未安装 flatpak(请先自行安装)"; return 1; }
  flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  flatpak info "$1" &>/dev/null || flatpak install --user -y flathub "$1"
}
