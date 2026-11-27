local M = {}

function M.setup()
  require("config.pack").packadd({
    "nvim-web-devicons",
    "plenary.nvim",
    "nui.nvim",
    "neo-tree.nvim",
  })

  require("neo-tree").setup({
    close_if_last_window = true,
    filesystem = {
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    window = {
      position = "left",
      width = 30,
      mappings = { ["<space>"] = "none" },
    },
  })

  vim.keymap.set("n", "<leader>e", function()
    local is_special_buffer = vim.bo.buftype ~= "" or vim.bo.filetype == "ministarter"
    local options = {
      action = "focus",
      source = "filesystem",
      reveal = not is_special_buffer,
      toggle = true,
    }

    if is_special_buffer then
      options.dir = vim.fn.getcwd()
    end

    require("neo-tree.command").execute(options)
  end, { desc = "Toggle Neo-tree" })
end

return M
