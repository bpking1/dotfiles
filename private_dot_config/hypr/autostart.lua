-- 自启动

hl.on("hyprland.start", function()
    -- 环境导入(portal/screen sharing 需要)
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- 官方 polkit 认证代理(替代旧的 polkit-kde-authentication-agent)
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")

    -- OSD 服务器(音量/亮度/大小写指示)
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("swayosd-libinput-backend")

    -- 输入法
    hl.exec_cmd("fcitx5 -d")

    -- 壁纸(wpaperd 已由官方 hyprpaper 替代)
    hl.exec_cmd("hyprpaper")

    -- 状态栏 / 通知 / 托盘
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("nm-applet --indicator")

    -- 剪贴板历史
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- pot 翻译/OCR(需自行安装: flatpak install com.pot_app.pot)
    hl.exec_cmd("env GDK_BACKEND=x11 WEBKIT_DISABLE_DMABUF_RENDERER=1 flatpak run com.pot_app.pot")

    -- 空闲管理(自动锁屏/息屏, 见 hypridle.conf)
    hl.exec_cmd("hypridle")

    -- 插件加载(插件不跨重启持久, 每次启动需重新载入; -n 成功后弹通知)
    -- hl.exec_cmd("sleep 2     hl.exec_cmd("sleep 2 && hyprpm reload -n")    hl.exec_cmd("sleep 2 && hyprpm reload -n") hyprpm reload -n")  -- 排查:暂停插件加载

    -- 延迟应用 HDR/FreeSync(启动期应用会在 F44/Mesa26 下崩溃,等合成器就绪再切)
    hl.exec_cmd("sleep 6 && hyprctl eval 'hl.monitor({ output = \"DP-1\", cm = \"hdr\", vrr = 1, sdr_max_luminance = 200, sdrbrightness = 1.5 })'")
end)
