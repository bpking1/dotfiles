-- Plugin code and its integration example are versioned with EnglishCD.
local M = {}
function M.setup()
  local path = vim.env.ENGLISHCD_NVIM_PATH or "/home/hj/workspace/englishcd/neovim"
  if vim.fn.filereadable(path .. "/examples/minideps.lua") ~= 1 then
    vim.notify("EnglishCD: 插件目录不存在，请设置 ENGLISHCD_NVIM_PATH", vim.log.levels.WARN)
    return
  end
  dofile(path .. "/examples/minideps.lua").setup()
end
return M
