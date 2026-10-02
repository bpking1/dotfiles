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

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(event)
      local opts = { buffer = event.buf }
      local map = vim.keymap.set

      map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP: 跳转到定义" }))
      map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "LSP: 查找所有引用" }))
      map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "LSP: 显示悬浮文档" }))
      map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "LSP: 重命名符号" }))
      map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "LSP: 修复动作 (Code Action)" }))
    end,
  })

  local capabilities = require("blink.cmp").get_lsp_capabilities()
  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = { vim.env.VIMRUNTIME },
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })
  vim.lsp.enable("lua_ls")
  vim.lsp.config("roslyn", { capabilities = capabilities })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
    callback = function(event)
      vim.lsp.buf.format({ bufnr = event.buf, async = false })
    end,
  })
end

return M
