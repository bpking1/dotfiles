local M = {}

function M.setup_lazy()
  local loaded = false

  local function load()
    if loaded then return end
    loaded = true

    -- 在 packadd 之前设置全局选项，确保 plugin/mkdp.vim 加载时读到最新配置
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_filetypes = { "markdown" }

    require("config.pack").packadd({
      "nvim-treesitter",
      "render-markdown.nvim",
      "markdown-preview.nvim",
    })
    require("render-markdown").setup({ file_types = { "markdown" } })
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("LazyMarkdownPlugins", { clear = true }),
    pattern = "markdown",
    callback = function()
      local was_loaded = loaded
      load()
      -- markdown-preview.nvim 的命令在 mkdp_init 组的 FileType 时创建；仅对该组补发事件避免重复触发 ftplugin
      if not was_loaded then
        pcall(vim.api.nvim_exec_autocmds, "FileType", {
          group = "mkdp_init",
          pattern = "markdown",
          modeline = false,
        })
      end
    end,
  })

  local map = vim.keymap.set
  map("n", "<leader>mp", function()
    load()
    vim.fn["mkdp#util#toggle_preview"]()
  end, { desc = "Markdown: Toggle Preview" })
  map("n", "<leader>ms", function()
    load()
    vim.fn["mkdp#util#stop_preview"]()
  end, { desc = "Markdown: Stop Preview" })
end

return M
