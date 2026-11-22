-- 开启内置 Lua 模块字节码缓存，加快启动速度
if vim.loader then
  vim.loader.enable()
end

-- 加载基础编辑器设置
require("config.options")

-- 加载诊断配置
require("config.diagnostics")

-- 加载自定义快捷键
require("config.keymaps")

-- 加载原生管理的插件
require("config.plugins")
