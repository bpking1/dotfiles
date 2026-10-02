local M = {}

function M.setup_lazy()
  local loaded = false
  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("LazyRoslyn", { clear = true }),
    pattern = "cs",
    callback = function()
      if loaded then return end
      loaded = true

      MiniDeps.add({ source = "seblyng/roslyn.nvim" })
      require("roslyn").setup({})
    end,
  })
end

return M
