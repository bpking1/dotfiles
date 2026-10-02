local M = {}

function M.setup_lazy()
  local loaded = false

  local function load()
    if loaded then return end
    loaded = true

    MiniDeps.add({ source = "folke/sidekick.nvim" })
    require("sidekick").setup({
      picker = "fzf-lua",
      cli = {
        tools = {
          antigravity = { cmd = { "agy" } },
        },
      },
    })
  end

  local map = vim.keymap.set
  map({ "n", "t", "i", "x" }, "<C-.>", function()
    load()
    require("sidekick.cli").focus()
  end, { desc = "Sidekick Focus" })
  map("n", "<leader>aa", function()
    load()
    require("sidekick.cli").toggle()
  end, { desc = "Sidekick Toggle CLI" })
  map("n", "<leader>as", function()
    load()
    require("sidekick.cli").select()
  end, { desc = "Sidekick Select CLI" })
  map("n", "<leader>ad", function()
    load()
    require("sidekick.cli").close()
  end, { desc = "Sidekick Detach CLI" })
  map({ "x", "n" }, "<leader>at", function()
    load()
    require("sidekick.cli").send({ msg = "{this}" })
  end, { desc = "Sidekick Send This" })
  map("n", "<leader>af", function()
    load()
    require("sidekick.cli").send({ msg = "{file}" })
  end, { desc = "Sidekick Send File" })
  map("x", "<leader>av", function()
    load()
    require("sidekick.cli").send({ msg = "{selection}" })
  end, { desc = "Sidekick Send Visual Selection" })
  map({ "n", "x" }, "<leader>ap", function()
    load()
    require("sidekick.cli").prompt()
  end, { desc = "Sidekick Select Prompt" })
end

return M
