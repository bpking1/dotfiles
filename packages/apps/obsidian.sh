# name: Obsidian 笔记(Flatpak)
# scope: desktop

app_installed() { flatpak info md.obsidian.Obsidian &>/dev/null; }
app_install() { flatpak_app md.obsidian.Obsidian; }
