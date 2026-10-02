-- 窗口规则
-- 提示:用 `hyprctl clients` 可查看窗口的 class / title

-- polkit 认证窗口浮动
hl.window_rule({
    name  = "polkit-float",
    match = { class = "^(hyprpolkitagent|.*polkit-kde.*)$" },
    float = true,
})

-- pot 翻译窗口浮动 + 跟随鼠标
hl.window_rule({
    name  = "pot-float",
    match = { title = "^(Translator|Recognize|Translate|OCR|PopClip|Screenshot Translate)$" },
    float = true,
    move  = { "cursor_x", "cursor_y" },
})

-- 通用浮动小窗:靠左 1/4、垂直居中、960x540
local function floatSmall(name, match)
    hl.window_rule({
        name  = name,
        match = match,
        float = true,
        size  = { "960", "540" },
        move  = { "(monitor_w*0.25)", "(monitor_h*0.5)-(window_h*0.5)" },
    })
end

floatSmall("pip-float",     { title = "^Picture-in-Picture$" })
floatSmall("imv-float",     { class = "^imv$" })
floatSmall("mpv-float",     { class = "^mpv$" })
floatSmall("ncmpcpp-float", { class = "^ncmpcpp$" })

-- 弹出的终端浮窗(kitty --class=termfloat)
hl.window_rule({
    name     = "termfloat",
    match    = { class = "^termfloat$" },
    float    = true,
    size     = { "960", "540" },
    move     = { "(monitor_w*0.25)", "(monitor_h*0.5)-(window_h*0.5)" },
    rounding = 5,
})

-- 弹幕浮窗
hl.window_rule({
    name     = "danmufloat",
    match    = { class = "^danmufloat$" },
    float    = true,
    pin      = true,
    size     = { "960", "540" },
    move     = { "(monitor_w*0.25)", "(monitor_h*0.5)-(window_h*0.5)" },
    rounding = 5,
})

-- IM/音乐窗口半透明
hl.window_rule({ name = "tg-opacity",  match = { title = "^(TDesktop|Telegram|64Gram)$" }, opacity = "0.95" })
hl.window_rule({ name = "ncm-opacity", match = { title = "NetEase Cloud Music Gtk4" },     opacity = "0.95" })

-- kitty 进场动画
hl.window_rule({ name = "kitty-anim", match = { class = "^kitty$" }, animation = "slide right" })

-- 按窗口自动分配工作区
hl.window_rule({ name = "ws-tg",    match = { title = "^(TDesktop|Telegram|64Gram)$" }, workspace = "name:TG" })
hl.window_rule({ name = "ws-music", match = { class = "^musicfox$" },                   workspace = "name:Music" })
hl.window_rule({ name = "ws-note",  match = { class = "^notes$" },                      workspace = "name:Note" })
hl.window_rule({ name = "ws-ob",    match = { title = "^Obsidian$" },                   workspace = "name:OB" })

-- firefox 不做模糊
hl.window_rule({ name = "firefox-noblur", match = { class = "^firefox$" }, no_blur = true })

-- qq-float:悬浮 QQ 聊天窗(置顶小窗,固定右上区域,所有工作区可见)
hl.window_rule({
    name  = "qq-float-chat",
    match = { class = "^qq-float$" },
    float = true,
    pin   = true,   -- 需与 float 同用
    size  = { "380", "560" },
    move  = { "1500", "60" },
})
