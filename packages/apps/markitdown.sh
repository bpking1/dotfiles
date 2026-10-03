# name: markitdown(pipx, 文档转 Markdown)
# scope: all

app_installed() { command -v markitdown >/dev/null; }
app_install() {
  command -v pipx >/dev/null || { echo "未安装 pipx(见 fedora.txt / arch.txt 的开发工具分类)"; return 1; }
  pipx install markitdown
}
