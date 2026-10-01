-- 输入设备:键盘/触摸板/外设/手势

hl.config({
    input = {
        kb_layout  = "us",
        kb_options = "caps:escape",          -- CapsLock -> Esc

        follow_mouse = 2,
        float_switch_override_focus = 2,
        numlock_by_default = true,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- 旧配置的 epic mouse V1
hl.device({
    name        = "epic mouse V1",
    sensitivity = -0.5,
})

-- 四指横滑切换工作区(替代旧 gestures.workspace_swipe)
hl.gesture({
    fingers   = 4,
    direction = "horizontal",
    action    = "workspace",
})
