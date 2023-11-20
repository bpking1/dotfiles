return {
  { import = "lazyvim.plugins.extras.lang.markdown" },
  -- 用上面这个官方默认的配置就好了，需要改的话再覆写
  --   {
  --     "iamcco/markdown-preview.nvim",
  --     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  --     keys = {
  --       { "<leader>cp", "<cmd>MarkdownPreview<cr>", desc = "MarkdownPreview" },
  --     },
  --     ft = { "markdown" },
  --     build = function()
  --       vim.fn["mkdp#util#install"]()
  --     end,
  --   },
  --   每个语言的lsp配置写在一起好点，不用专门一个lspconfig.lua文件
  --   {
  --     "neovim/nvim-lspconfig",
  --     ---@class PluginLspOpts
  --     opts = {
  --       ---@type lspconfig.options
  --       servers = {
  --         marksman = {},
  --       },
  --     },
  --   },
}
