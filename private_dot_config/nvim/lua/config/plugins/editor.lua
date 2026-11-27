local M = {}

function M.setup()
  require("config.pack").packadd({ "flash.nvim", "quicker.nvim" })

  local flash = require("flash")
  flash.setup({
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = { multi_window = true },
  })

  vim.keymap.set({ "n", "x", "o" }, "s", function()
    flash.jump()
  end, { desc = "Flash Jump" })

  local quicker = require("quicker")
  quicker.setup({})
  vim.keymap.set("n", "<leader>uq", function()
    quicker.toggle()
  end, { desc = "Toggle Quickfix (Quicker)" })
end

return M
