-- 外观:间隙/边框/圆角/模糊/动画

hl.config({
    general = {
        gaps_in     = 3,
        gaps_out    = 5,
        border_size = 3,

        col = {
            active_border   = "rgb(ffc0cb)",
            inactive_border = "rgba(595959aa)",
        },

        layout = "dwindle",
    },

    decoration = {
        rounding           = 8,
        active_opacity     = 1.0,
        inactive_opacity   = 1.0,
        fullscreen_opacity = 1.0,
        dim_inactive       = false,

        blur = {
            enabled        = true,
            size           = 3,
            passes         = 1,
            xray           = true,
            ignore_opacity = false,
        },
    },

    animations = {
        enabled = true,
    },
})

-- 动画曲线(旧配置的 overshot)
hl.curve("overshot", { type = "bezier", points = { {0.13, 0.99}, {0.29, 1.1} } })
hl.curve("default",  { type = "bezier", points = { {0.05, 0.7}, {0.1, 1}   } })

hl.animation({ leaf = "windows",    enabled = true, speed = 4, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade",       enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "overshot", style = "slidevert" })
