local M = {}

function M.setup_now()
  vim.cmd("colorscheme tokyonight-storm")
  require("mini.starter").setup({})
end

function M.setup_later()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },
      { mode = "n", keys = "g" },
      { mode = "x", keys = "g" },
      { mode = "n", keys = "<C-w>" },
      { mode = "n", keys = '"' },
      { mode = "x", keys = '"' },
      { mode = "n", keys = "'" },
      { mode = "n", keys = "`" },
      { mode = "x", keys = "'" },
      { mode = "x", keys = "`" },
      { mode = "n", keys = "z" },
      { mode = "x", keys = "z" },
    },
    clues = {
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      { mode = "n", keys = "<leader>a", desc = "+ai/sidekick" },
      { mode = "x", keys = "<leader>a", desc = "+ai/sidekick" },
      { mode = "n", keys = "<leader>b", desc = "+buffer" },
      { mode = "n", keys = "<leader>c", desc = "+code" },
      { mode = "x", keys = "<leader>c", desc = "+code" },
      { mode = "n", keys = "<leader>f", desc = "+find" },
      { mode = "n", keys = "<leader>g", desc = "+git" },
      { mode = "n", keys = "<leader>m", desc = "+markdown" },
      { mode = "n", keys = "<leader>q", desc = "+quit" },
      { mode = "n", keys = "<leader>r", desc = "+refactor" },
      { mode = "n", keys = "<leader>s", desc = "+search/symbols" },
      { mode = "n", keys = "<leader>u", desc = "+ui/toggle" },
    },
  })

  require("mini.statusline").setup({})
  require("mini.tabline").setup({})
  require("mini.diff").setup({
    view = {
      style = "sign",
      priority = 5, -- 默认 199，避免覆盖 DAP 断点符号 (priority 10)
    },
  })
  vim.keymap.set("n", "<leader>ud", function()
    require("mini.diff").toggle_overlay(0)
  end, { desc = "Toggle Git Diff Overlay" })

  require("mini.pairs").setup({})
end

return M
