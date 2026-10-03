-- 插件配置(hyprbars / borders-plus-plus / dynamic-cursors)
-- 写法参考官方 README:hl.config({ plugin = { <插件> = {...} } })

hl.on("config.reloaded", function()
hl.config({
    plugin = {
        -- 标题栏:Catppuccin Mocha 配色 + 霞鹜文楷
        -- (暂时不用 hyprbars 了,已 hyprpm disable;想用时:
        --  1. hyprpm enable hyprbars  2. 取消下面的注释)
        -- hyprbars = {
        --     bar_height            = 22,
        --     bar_color             = "rgb(1e1e2e)",   -- Mocha Base
        --     bar_blur              = true,
        --     bar_part_of_window    = true,
        --     bar_precedence_over_border = false,
        --     bar_text_size         = 11,
        --     bar_text_font         = "LXGW WenKai",
        --     bar_text_align        = "center",
        --     bar_button_padding    = 5,
        --     bar_padding           = 7,
        --     col                   = { text = "rgb(cdd6f4)" },  -- Mocha Text
        --     on_double_click       = "hyprctl dispatch fullscreen 1",
        -- },

        -- 双描边:紧贴窗口一圈粉色呼应 active_border
        borders_plus_plus = {
            add_borders      = 1,
            natural_rounding = true,
            col              = { border_1 = "rgb(ffc0cb)" },
            border_size_1    = 2,
        },

        -- 光标动效:快速移动时倾斜 + 摇晃放大找光标
        -- (想更夸张可把 mode 改成 "stretch" 拉伸挤压效果)
        dynamic_cursors = {
            enabled   = true,
            mode      = "tilt",
            threshold = 2,
            shake     = {
                enabled   = true,
                threshold = 6.0,
            },
        },

        -- 双屏独立工作区插件已停用;其配置键在该构建中未注册,移除
        -- (恢复插件时如需限制数量,用运行时调用:
        --  hl.plugin.split_monitor_workspaces.max_workspaces({ monitor = "DP-1", max = 5 }))

        -- hyprfocus:键盘切换焦点时窗口闪烁(鼠标划过不触发,避免乱闪)
        -- 动画可选 "flash"(透明度闪)/ "shrink"(收缩)/ "slide"(上滑)
        hyprfocus = {
            enable                   = true,
            keyboard_focus_animation = "shrink",
            mouse_focus_animation    = "none",
            fade_opacity             = 0.8,
        },
    },
})
end)
