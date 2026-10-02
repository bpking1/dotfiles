local M = {}

function M.setup()
  local add = MiniDeps.add
  add({ source = "folke/flash.nvim" })

  local flash = require("flash")
  flash.setup({
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = { multi_window = true },
  })

  vim.keymap.set({ "n", "x", "o" }, "s", function()
    flash.jump()
  end, { desc = "Flash Jump" })
end

return M
