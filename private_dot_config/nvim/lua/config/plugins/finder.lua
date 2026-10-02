local M = {}

function M.setup()
  local add = MiniDeps.add
  local map = vim.keymap.set

  add({ source = "ibhagwan/fzf-lua" })
  require("fzf-lua").setup({
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
end

return M
