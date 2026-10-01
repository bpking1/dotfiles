-- Hyprland 0.56+ Lua 配置入口
-- 由两年前的 hyprland.conf (hyprlang) 迁移而来
-- Wiki: https://wiki.hypr.land/configuring/
--
-- 模块化说明:每个 require 在独立的 Lua 作用域中执行,
-- 互不影响,出错也不会中断整体加载。
-- Lua stubs(补全)安装后在 /usr/share/hypr/stubs/,可配置到 LSP。

require("monitors")      -- 显示器
require("env")           -- 环境变量
require("autostart")     -- 自启动
require("appearance")    -- 外观:间隙/边框/圆角/模糊/动画
require("input")         -- 输入:键盘/鼠标/触摸板/手势
require("workspaces")    -- 工作区行为
require("misc")          -- 杂项 + dwindle 布局
require("windowrules")   -- 窗口规则
require("keybinds")      -- 按键绑定
require("plugins")       -- 插件配置(hyprbars/borders++/dynamic-cursors)
