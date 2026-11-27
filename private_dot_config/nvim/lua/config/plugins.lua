-- 必须在首次 vim.pack.add() 之前注册 PackChanged，确保首次安装或从锁文件恢复时也能触发构建钩子
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("UserPackHooks", { clear = true }),
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "markdown-preview.nvim" and (kind == "install" or kind == "update") then
      local result = vim.system({ "npm", "install" }, {
        cwd = ev.data.path .. "/app",
        text = true,
      }):wait()

      if result.code ~= 0 then
        vim.notify(
          "markdown-preview.nvim npm install 失败:\n" .. (result.stderr or ""),
          vim.log.levels.ERROR
        )
      end
    end
  end,
})

local pack = require("config.pack")
pack.setup_commands()

local function gh(repo)
  return "https://github.com/" .. repo
end

-- 1. 首屏必需插件：立即加载
vim.pack.add({
  gh("folke/tokyonight.nvim"),
  gh("nvim-mini/mini.nvim"),
}, { confirm = false })

-- 2. 延迟/按需插件：统一并发安装并写入锁文件，通过空 load 函数延迟到实际使用时再 packadd
vim.pack.add({
  -- 延迟加载阶段使用
  gh("ibhagwan/fzf-lua"),
  gh("folke/flash.nvim"),
  gh("stevearc/quicker.nvim"),
  gh("rafamadriz/friendly-snippets"),
  { src = gh("saghen/blink.cmp"), version = "v1.10.2" },
  gh("mason-org/mason.nvim"),
  gh("WhoIsSethDaniel/mason-tool-installer.nvim"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("nvim-lua/plenary.nvim"),
  gh("MunifTanjim/nui.nvim"),
  { src = gh("nvim-neo-tree/neo-tree.nvim"), version = "v3.x" },
  -- 触发事件/快捷键时按需加载
  gh("nvim-treesitter/nvim-treesitter"),
  gh("MeanderingProgrammer/render-markdown.nvim"),
  gh("iamcco/markdown-preview.nvim"),
  gh("seblyng/roslyn.nvim"),
  gh("mfussenegger/nvim-dap"),
  gh("folke/sidekick.nvim"),
  gh("sindrets/diffview.nvim"),
}, {
  confirm = false,
  load = function() end,
})

-- 首屏界面必须立即初始化
require("config.plugins.ui").setup_now()

-- 注册按文件类型或快捷键按需触发的懒加载模块
require("config.plugins.markdown").setup_lazy()
require("config.plugins.roslyn").setup_lazy()
require("config.plugins.dap").setup_lazy()
require("config.plugins.sidekick").setup_lazy()
require("config.plugins.git").setup_lazy()

-- 保持既定的顺序延迟加载，确保 ui.setup_later() 先于 englishcd.setup() 执行
pack.later(function()
  require("config.plugins.finder").setup()
  require("config.plugins.ui").setup_later()
  require("config.plugins.editor").setup()
  require("config.plugins.englishcd").setup()
end)

pack.later(function()
  require("config.plugins.lsp").setup()
end)

pack.later(function()
  require("config.plugins.files").setup()
end)
