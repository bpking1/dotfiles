local M = {}

function M.setup()
  local map = vim.keymap.set

  require("config.pack").packadd("fzf-lua")
  require("fzf-lua").setup({
    fzf_colors = true,
    files = {
      follow = true,
    },
    grep = {
      follow = true,
    },
  })
  require("fzf-lua").register_ui_select()

  map("n", "<leader>ff", "<cmd>FzfLua files<cr>", { desc = "Find files (FzfLua)" })
  map("n", "<leader>fg", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep (FzfLua)" })
  map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Live grep (FzfLua)" })
  map("n", "<leader>fb", "<cmd>FzfLua buffers<cr>", { desc = "Find buffers (FzfLua)" })
  map("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", { desc = "Find help tags (FzfLua)" })
  map("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>", { desc = "Search keymaps (FzfLua)" })
end

return M
