-- 工作区行为

hl.config({
    binds = {
        workspace_back_and_forth = true,   -- 切到当前工作区时跳回上一个
        allow_workspace_cycles   = true,
    },
})

-- 数字工作区固定显示器(不随焦点漂移):1-7 主屏,8-0 副屏
for i = 1, 7 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "DP-1" })
end
for i = 8, 9 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end
hl.workspace_rule({ workspace = "10", monitor = "HDMI-A-1" })
