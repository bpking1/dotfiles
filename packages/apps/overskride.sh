# name: Overskride 蓝牙管理(Flatpak, waybar 引用)
# scope: desktop

app_installed() { flatpak info io.github.kaii_lb.Overskride &>/dev/null; }
app_install() { flatpak_app io.github.kaii_lb.Overskride; }
