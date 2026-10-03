-- 显示器配置

hl.monitor({
    output   = "DP-1",
    mode     = "3840x2160@160",
    position = "0x0",
    scale    = 1.5,
    -- HDR 在启动期应用会使 F44/Mesa26 下 EGL 崩溃,改为登录后延迟应用(见 autostart.lua)
    -- bitdepth = 10, cm = "hdr", vrr = 1, sdr_max_luminance = 200, sdrbrightness = 1.5
})

hl.monitor({
    output    = "HDMI-A-1",
    mode      = "1920x1080",
    position  = "-1080x0",
    scale     = 1,
    transform = 1,
})

-- 未匹配到的显示器:自动放在最右侧
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
