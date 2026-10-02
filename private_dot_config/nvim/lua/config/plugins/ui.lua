local M = {}

function M.setup_now()
  local add = MiniDeps.add

  add({ source = "folke/tokyonight.nvim" })
  vim.cmd("colorscheme tokyonight-storm")

  add({ source = "echasnovski/mini.nvim" })
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
      { mode = "n", keys = "<leader>b", desc = "+buffer" },
      { mode = "n", keys = "<leader>f", desc = "+find" },
      { mode = "n", keys = "<leader>m", desc = "+markdown" },
      { mode = "n", keys = "<leader>q", desc = "+quit" },
    },
  })

  require("mini.statusline").setup({})
  require("mini.tabline").setup({})
  require("mini.diff").setup({})
  require("mini.pairs").setup({})
end

return M
