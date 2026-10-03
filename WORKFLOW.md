# Dotfiles 工作流(NixOS 式声明式管理)

| NixOS 概念 | 本仓库对应 |
|---|---|
| configuration.nix | 本仓库(chezmoi source)|
| nixos-rebuild switch | `chezmoi apply` |
| nixos-rebuild test | `chezmoi diff` / `chezmoi apply --dry-run` |
| environment.systemPackages | `packages/common.txt` + `fedora.txt`/`arch.txt`(文件内 `[desktop]` 段仅桌面模式安装)|
| 世代回滚 | git tag → checkout → `chezmoi apply` |

## 本机角色(桌面 / 服务器)
- 由 chezmoi 数据 `.desktop` 决定(`.chezmoi.toml.tmpl`), **不看主机名**; `chezmoi init` 时按图形会话探测默认值并询问一次, 之后记住
- 桌面: 装清单全部(含 `[desktop]` 段), 铺 hypr/waybar/fontconfig/壁纸, 跑字体/mpv-handler 脚本
- 服务器: 只装各清单 `[desktop]` 之前的部分, 以上桌面内容全部跳过(`.chezmoiignore` 统一控制)
- 切换角色: `chezmoi init --prompt --promptBool 'desktop (本机是桌面工作站吗, 否则按服务器处理)=true'`(false 反之), 再 `chezmoi apply`
- 包清单脚本可用 `DESKTOP=0/1` 环境变量临时覆盖, 不改变 chezmoi 数据

## 日常操作
- **手动改了配置,收编回声明**: `chezmoi re-add`
- **应用声明**: `chezmoi apply`
- **预览会改什么**: `chezmoi diff`
- **新机器恢复**: 装 chezmoi → `chezmoi init bpking1/dotfiles` → `chezmoi apply`(自动执行软件恢复脚本+铺配置)
- **软件选择**: 首次恢复时交互勾选(默认全选): 清单分类(`# ==== 名称 ====`)+ `packages/apps/` 下的应用; 选择记录在 `~/.config/chezmoi/selection`
  - 重新选择: `chezmoi state delete-bucket --bucket=scriptState && RECONFIGURE=1 chezmoi apply`
  - 无终端(如自动化)时不弹菜单, 按已有选择或全选安装
- **增删软件**:
  - 系统包: 编辑 `packages/common.txt` / `fedora.txt` / `arch.txt`(放在合适的 `# ==== 分类 ====` 下), 同机再 `dnf install/remove`
  - 包管理器没有的软件(下载 / Flatpak / COPR 等): 在 `packages/apps/` 新增 `<id>.sh`, 格式见 `packages/apps/_lib.sh` 开头; 自动出现在勾选菜单并由 `run_onchange_after_20-install-apps` 安装, **无需修改任何已有脚本**
- **打"世代"标签**: `git tag gen-$(date +%Y%m%d) && git push --tags`
- **回滚到某世代**: `git checkout gen-XXXXXXXX && chezmoi apply`

## 非 rpm 安装的软件(重装系统时需手动恢复)
- **swayosd** 三件套(`/usr/local/bin`,音量/亮度 OSD,keybinds 5 处引用)
  - 上游: https://github.com/ErikReider/SwayOSD(无 release 二进制,需 cargo+meson 编译)
  - 现有版本装于 2026-10-02,配置无额外文件,重装系统后按上游 README 编译即可
- 其余(mise / 字体 / ffmpeg / Claude Code / Codex / agy / opencode / Rime / Obsidian / Sunshine 等)均为 `packages/apps/<id>.sh`, 由 chezmoi 在 apply 时按勾选安装; mise 管理的工具见 `private_dot_config/mise/config.toml`

## 待实施
- waybar 歌词模块(已定方案:mpdris2/MPRIS 拿曲名 → API 拉 LRC → custom module;脚本未写)
