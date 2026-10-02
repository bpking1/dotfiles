local M = {}

function M.setup_lazy()
  local add = MiniDeps.add
  local loaded = false

  local function load()
    if loaded then return end
    loaded = true

    add({ source = "nvim-treesitter/nvim-treesitter" })
    add({ source = "MeanderingProgrammer/render-markdown.nvim" })
    require("render-markdown").setup({ file_types = { "markdown" } })

    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_filetypes = { "markdown" }

    local install_markdown_preview = function(plugin)
      local result = vim.system({ "npm", "install" }, {
        cwd = plugin.path .. "/app",
        text = true,
      }):wait()

      if result.code ~= 0 then
        error("markdown-preview.nvim npm install failed: " .. result.stderr)
      end
    end

    add({
      source = "iamcco/markdown-preview.nvim",
      hooks = {
        post_install = install_markdown_preview,
        post_checkout = install_markdown_preview,
      },
    })
    vim.cmd("runtime! plugin/mkdp.vim")
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("LazyMarkdownPlugins", { clear = true }),
    pattern = "markdown",
    callback = function()
      local was_loaded = loaded
      load()
      -- markdown-preview.nvim 的命令在 FileType 时创建；插件刚加载时补发事件。
      if not was_loaded then
        vim.api.nvim_exec_autocmds("FileType", { pattern = "markdown", modeline = false })
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
