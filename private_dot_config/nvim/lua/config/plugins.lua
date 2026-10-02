-- 引导并初始化 mini.deps
local path_package = vim.fn.stdpath("data") .. "/site/pack/deps/start/mini.deps"
if not (vim.uv or vim.loop).fs_stat(path_package) then
  vim.api.nvim_echo({ { "正在下载 mini.deps 插件管理器，请稍后...", "InfoMsg" } }, true, {})
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/echasnovski/mini.deps",
    path_package,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "克隆 mini.deps 失败：\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end

require("mini.deps").setup({})

local now, later = MiniDeps.now, MiniDeps.later

-- 首屏所需插件必须立即加载。
now(function()
  require("config.plugins.ui").setup_now()
end)

-- 注册真正按需加载的文件类型事件与快捷键，不在启动时加载插件。
require("config.plugins.markdown").setup_lazy()
require("config.plugins.roslyn").setup_lazy()
require("config.plugins.dap").setup_lazy()
require("config.plugins.sidekick").setup_lazy()

-- 保持原有的延迟加载顺序，具体配置按功能拆分到独立文件。
later(function()
  require("config.plugins.finder").setup()
  require("config.plugins.ui").setup_later()
  require("config.plugins.editor").setup()
  require("config.plugins.englishcd").setup()
end)

later(function()
  require("config.plugins.lsp").setup()
end)

later(function()
  require("config.plugins.files").setup()
end)
