-- 按键绑定 —— 完整保留旧 hyprland.conf 的快捷键
-- 变更:swaylock->hyprlock, light->brightnessctl, pamixer->wpctl,
--      rofi launcher->hyprlauncher, powermenu.sh->wlogout,
--      QQ/Chrome 改为 flatpak 启动

local mainMod  = "ALT"
local terminal = "kitty"

------------------------------------
---- pot 翻译 / OCR ----
------------------------------------
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png && curl "127.0.0.1:60828/ocr_recognize?screenshot=false"'))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd('grim -g "$(slurp)" ~/.cache/com.pot-app.desktop/pot_screenshot_cut.png && curl "127.0.0.1:60828/ocr_translate?screenshot=false"'))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd('curl "127.0.0.1:60828/selection_translate"'))

-- 剪贴板历史选择
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))

-- 终端
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd('kitty --class="termfloat"'))

-- web 搜索脚本(需恢复 ~/.config/rofi/web-search.sh)
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("~/.config/rofi/web-search.sh"))

------------------------------------
---- 窗口操作 ----
------------------------------------
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.close())            -- 关闭窗口
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())                    -- 退出 Hyprland
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.float())        -- 浮动切换
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())               -- 全屏
hl.bind(mainMod .. " + Y", hl.dsp.window.pin())                      -- 钉住
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())                   -- 伪平铺
hl.bind(mainMod .. " + Tab", hl.dsp.group.next())                    -- 组内切换(原 changegroupactive f)
-- hl.bind(mainMod .. " + K", hl.dsp.group.toggle())                 -- 分组(旧配置注释掉了,按需启用)

-- 切换间隙大小
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.exec_cmd('hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"'))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd('hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"'))

------------------------------------
---- 焦点移动 ----
------------------------------------
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

------------------------------------
---- 工作区切换 ----
------------------------------------
for i = 1, 10 do
    hl.bind(mainMod .. " + " .. (i % 10), hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. (i % 10), hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. (i % 10), hl.dsp.window.move({ workspace = i, follow = false }))
    -- split-monitor-workspaces 插件版(双屏独立编号,已停用;要用换回这三行):
    -- hl.bind(mainMod .. " + " .. (i % 10), function() hl.plugin.split_monitor_workspaces.workspace(i) end)
    -- hl.bind(mainMod .. " + SHIFT + " .. (i % 10), function() hl.plugin.split_monitor_workspaces.move_to_workspace_silent(i) end)
    -- hl.bind(mainMod .. " + CTRL + " .. (i % 10), function() hl.plugin.split_monitor_workspaces.move_to_workspace(i) end)
end

hl.bind(mainMod .. " + L", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + slash",  hl.dsp.focus({ workspace = "previous" }))

-- 命名工作区 + 启动对应应用(旧配置里同键绑定了两条,这里合并)
-- ALT+Q 已改为 qq-float 悬浮窗开关(见下方),旧的"跳QQ工作区+linuxqq"绑定移除
hl.bind(mainMod .. " + T", function()   -- Telegram(64gram 未安装时仅切换工作区)
    hl.dispatch(hl.dsp.focus({ workspace = "name:TG" }))
    hl.dispatch(hl.dsp.exec_cmd("64gram-desktop"))
end)
hl.bind(mainMod .. " + M", hl.dsp.focus({ workspace = "name:Music" }))
hl.bind(mainMod .. " + N", hl.dsp.focus({ workspace = "name:Note" }))
hl.bind(mainMod .. " + O", function()   -- Obsidian 工作区 + waybar 开关
    hl.dispatch(hl.dsp.focus({ workspace = "name:OB" }))
    hl.dispatch(hl.dsp.exec_cmd("killall -SIGUSR1 waybar || true"))
end)
hl.bind(mainMod .. " + D", function()   -- Simple Live 直播播放器(B站/斗鱼/虎牙/抖音)
    hl.dispatch(hl.dsp.focus({ workspace = "name:Live" }))
    hl.dispatch(hl.dsp.exec_cmd("$HOME/.local/opt/simple-live/simple_live_app"))
end)

------------------------------------
---- 特殊工作区(scratchpad) ----
------------------------------------
hl.bind(mainMod .. " + minus", hl.dsp.window.move({ workspace = "special:scratch" }))
hl.bind(mainMod .. " + equal", hl.dsp.workspace.toggle_special("scratch"))

------------------------------------
---- 工作区内移动窗口 ----
------------------------------------
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ workspace = "+1" }))

-- 滚轮切换工作区
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

------------------------------------
---- 快速启动 ----
------------------------------------
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("flatpak run com.google.Chrome --enable-wayland-ime"))   -- Chrome(Flatpak + Wayland 原生输入法)
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("flatpak run md.obsidian.Obsidian --enable-wayland-ime"))  -- Obsidian(未装 Flatpak 时可改回本地命令)
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd('kitty --class="notes" --hold sh -c "cd ~/obsidian-vault && nvim"'))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd('kitty --class="musicfox" --hold sh -c "pkill mpd; musicfox"'))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("zotero"))

-- 锁屏(swaylock -> 官方 hyprlock)
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("hyprlock"))

-- 通知中心面板(swaync)
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("swaync-client -t -sw"))

-- 屏幕录制开关(wf-recorder,无音频,保存到 ~/视频)
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("$HOME/.config/waybar/scripts/rec-toggle"))

-- 截图
hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd('grimblast --notify --cursor copysave area ~/图片/$(date "+%Y-%m-%d"T"%H:%M:%S_no_watermark").png'))
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))

-- 启动器 / 电源菜单
hl.bind("Super_L", hl.dsp.exec_cmd("hyprlauncher"))          -- 应用启动器(替代 rofi launcher.sh)
hl.bind(mainMod .. " + Super_L", hl.dsp.exec_cmd("wlogout")) -- 电源菜单(替代 rofi powermenu.sh)

------------------------------------
---- 官方插件 ----
------------------------------------
-- hyprexpo:全局工作区概览(函数包裹:启动时插件未加载也不报错)
hl.bind(mainMod .. " + grave", function() hl.dispatch(hl.plugin.hyprexpo.expo) end)

-- scrolling 布局试玩开关(PaperWM 式横向画布,全局切换 dwindle/scrolling)
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("hyprctl getoption -j general:layout | grep -q scrolling && hyprctl keyword general:layout dwindle > /dev/null || hyprctl keyword general:layout scrolling > /dev/null"))

-- hyprsunset 护眼模式开关(4500K)
hl.bind(mainMod .. " + F10", hl.dsp.exec_cmd("pgrep -x hyprsunset > /dev/null && pkill hyprsunset || hyprsunset -t 4500"))

------------------------------------
---- 音量 / 亮度 / 媒体 ----
------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("swayosd-client --brightness +5"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness -5"), { repeating = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("mpc -q toggle"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("mpc -q next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("mpc -q prev"))

------------------------------------
---- submap:调整窗口大小 ----
------------------------------------
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 15,  y = 0,  relative = true }), { repeating = true })
    hl.bind("left",  hl.dsp.window.resize({ x = -15, y = 0,  relative = true }), { repeating = true })
    hl.bind("up",    hl.dsp.window.resize({ x = 0,   y = -15, relative = true }), { repeating = true })
    hl.bind("down",  hl.dsp.window.resize({ x = 0,   y = 15,  relative = true }), { repeating = true })
    hl.bind("l",     hl.dsp.window.resize({ x = 15,  y = 0,  relative = true }), { repeating = true })
    hl.bind("h",     hl.dsp.window.resize({ x = -15, y = 0,  relative = true }), { repeating = true })
    hl.bind("k",     hl.dsp.window.resize({ x = 0,   y = -15, relative = true }), { repeating = true })
    hl.bind("j",     hl.dsp.window.resize({ x = 0,   y = 15,  relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- 直接 CTRL+SHIFT+方向/vim 键调整大小
hl.bind("CTRL + SHIFT + l", hl.dsp.window.resize({ x = 15,  y = 0,  relative = true }), { repeating = true })
hl.bind("CTRL + SHIFT + h", hl.dsp.window.resize({ x = -15, y = 0,  relative = true }), { repeating = true })
hl.bind("CTRL + SHIFT + k", hl.dsp.window.resize({ x = 0,   y = -15, relative = true }), { repeating = true })
hl.bind("CTRL + SHIFT + j", hl.dsp.window.resize({ x = 0,   y = 15,  relative = true }), { repeating = true })

------------------------------------
---- 鼠标拖动窗口 ----
------------------------------------
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- qq-float 悬浮聊天窗开关(隐藏/显示,进程常驻不掉线)
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/qq-float-toggle"))
