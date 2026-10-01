-- 杂项 + dwindle 布局

hl.config({
    misc = {
        disable_autoreload     = true,     -- 保存配置不自动重载(手动 hyprctl reload)
        disable_hyprland_logo  = true,
        enable_swallow         = true,     -- 终端打开同类窗口时吞并
        animate_manual_resizes = false,
        focus_on_activate      = true,
    },
})

hl.config({
    dwindle = {
        force_split            = 0,
        special_scale_factor   = 0.8,
        split_width_multiplier = 1.0,
        use_active_for_splits  = true,
        preserve_split         = true,
    },
})
