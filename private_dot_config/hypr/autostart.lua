-- 自启动

hl.on("hyprland.start", function()
    -- 环境导入(portal/screen sharing 需要)
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- 官方 polkit 认证代理(替代旧的 polkit-kde-authentication-agent)
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")

    -- 输入法
    hl.exec_cmd("fcitx5 -d")

    -- 壁纸(wpaperd 已由官方 hyprpaper 替代)
    hl.exec_cmd("hyprpaper")

    -- 状态栏 / 通知 / 托盘
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("nm-applet --indicator")

    -- 剪贴板历史
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- pot 翻译/OCR(需自行安装: flatpak install com.pot_app.pot)
    hl.exec_cmd("env GDK_BACKEND=x11 WEBKIT_DISABLE_DMABUF_RENDERER=1 flatpak run com.pot_app.pot")

    -- 空闲管理(自动锁屏/息屏, 见 hypridle.conf)
    hl.exec_cmd("hypridle")
end)
