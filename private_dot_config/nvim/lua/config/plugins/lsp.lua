local M = {}

function M.setup()
  local add = MiniDeps.add

  add({ source = "rafamadriz/friendly-snippets" })
  add({ source = "saghen/blink.cmp", checkout = "v1.10.2" })
  require("blink.cmp").setup({
    keymap = { preset = "enter" },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
  })

  add({ source = "williamboman/mason.nvim" })
  require("mason").setup({
    registries = {
      "github:Crashdummyy/mason-registry",
      "github:mason-org/mason-registry",
    },
  })

  add({ source = "WhoIsSethDaniel/mason-tool-installer.nvim" })
  require("mason-tool-installer").setup({
    ensure_installed = {
      "lua-language-server",
      "roslyn",
      "netcoredbg",
    },
    auto_update = false,
    run_on_start = true,
    start_delay = 3000,
  })

  -- 删除 Neovim 0.11+ 默认的 gr* 映射，避免按 gr 查找引用时触发 timeoutlen 等待
  for _, item in ipairs({
    { "n", "grn" },
    { "n", "gra" },
    { "x", "gra" },
    { "n", "grr" },
    { "n", "gri" },
    { "n", "grt" },
    { { "n", "x" }, "grx" },
  }) do
    pcall(vim.keymap.del, item[1], item[2])
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(event)
      local opts = { buffer = event.buf }
      local map = vim.keymap.set

      map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: 跳转到定义" }))
      map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "LSP: 跳转到声明" }))
      map("n", "gI", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "LSP: 跳转到实现" }))
      map("n", "gy", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "LSP: 跳转到类型定义" }))
      map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP: 查找所有引用", nowait = true }))
      map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: 显示悬浮文档" }))
      map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: 重命名符号" }))
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: 修复动作 (Code Action)" }))
    end,
  })

  local capabilities = require("blink.cmp").get_lsp_capabilities()
  vim.lsp.config("*", { capabilities = capabilities })

  -- 自动扫描 ~/.config/nvim/lsp/*.lua 并启用（仅扫描个人配置目录，避免误启第三方插件自带的 lsp/）
  -- roslyn 由 roslyn.nvim 在打开 cs 文件时按需启动，自动继承 "*" 的 capabilities
  local lsp_dir = vim.fn.stdpath("config") .. "/lsp"
  local uv = vim.uv or vim.loop
  if uv.fs_stat(lsp_dir) then
    local servers = {}
    for name, ftype in vim.fs.dir(lsp_dir) do
      if ftype == "file" and name:sub(-4) == ".lua" then
        table.insert(servers, name:sub(1, -5))
      end
    end
    if #servers > 0 then
      vim.lsp.enable(servers)
    end
  end

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
    callback = function(event)
      vim.lsp.buf.format({ bufnr = event.buf, async = false })
    end,
  })
end

return M
