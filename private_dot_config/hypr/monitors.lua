-- 显示器配置

hl.monitor({
    output   = "DP-1",
    mode     = "3840x2160@160",   -- 面板 EDID 支持到 160Hz(默认档 144)
    position = "0x0",
    scale    = 1.5,
    cm       = "hdr",   -- HDR 色彩管理
    vrr      = 1,       -- FreeSync/VRR,若屏幕出现亮度闪烁则删除此行
    -- SDR 内容在 HDR 模式下的亮度(相当于 Windows 的"SDR 内容亮度"滑块)
    sdr_max_luminance = 200,  -- SDR 白色映射到 200 nits(嫌暗加到 300/400)
    sdrbrightness     = 1.5,  -- SDR 内容整体亮度乘数
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
