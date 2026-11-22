local virtual_text_opts = {
  spacing = 4,
  source = "if_many",
  prefix = "●",
}
local virtual_text_on = true

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  virtual_text = virtual_text_opts,
  float = {
    border = "rounded",
    source = "if_many",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})

-- 启用 Neovim 0.12+ 原生行内颜色预览（不依赖额外插件）
if vim.lsp.document_color and vim.lsp.document_color.enable then
  vim.lsp.document_color.enable(true, nil, { style = "virtual" })
end

-- 切换诊断行内虚拟文本显示
vim.keymap.set("n", "<leader>uv", function()
  virtual_text_on = not virtual_text_on
  vim.diagnostic.config({ virtual_text = virtual_text_on and virtual_text_opts or false })
  vim.notify("诊断行内提示: " .. (virtual_text_on and "开启" or "关闭"))
end, { desc = "Toggle Diagnostic Virtual Text", noremap = true })

-- 在 Error / Warn 间快速跳转
vim.keymap.set("n", "[e", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Previous Error" })

vim.keymap.set("n", "]e", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = "Next Error" })

vim.keymap.set("n", "[w", function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
end, { desc = "Previous Warning" })

vim.keymap.set("n", "]w", function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
end, { desc = "Next Warning" })
