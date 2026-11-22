local M = {}

local state = {
  buf = nil,
  height_fraction = 0.35,
}

--- 解析当前项目根目录（优先 git 根目录，回退 cwd）
local function project_root()
  local buf_name = vim.api.nvim_buf_get_name(0)
  local start_path = (vim.bo.buftype == "" and buf_name ~= "") and buf_name or vim.fn.getcwd()
  return vim.fs.root(start_path, { ".git" }) or vim.fn.getcwd()
end

--- 判断终端缓冲区关联进程是否仍然存活
local function term_alive(buf)
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    return false
  end
  if vim.bo[buf].buftype ~= "terminal" then
    return false
  end
  local chan = vim.bo[buf].channel
  return chan ~= 0 and vim.fn.jobwait({ chan }, 0)[1] == -1
end

--- 查找当前标签页内展示该终端的非浮动窗口
local function find_term_win(buf)
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    return nil
  end
  local current_tab = vim.api.nvim_get_current_tabpage()
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if
      vim.api.nvim_win_is_valid(win)
      and vim.api.nvim_win_get_tabpage(win) == current_tab
      and vim.api.nvim_win_get_config(win).relative == ""
    then
      return win
    end
  end
  return nil
end

--- 在底部切换持久化的项目终端窗口
function M.toggle()
  local root = project_root()
  local win = find_term_win(state.buf)

  if win then
    if not pcall(vim.api.nvim_win_close, win, true) then
      pcall(vim.cmd, "enew")
      return
    end
    if not term_alive(state.buf) and state.buf and vim.api.nvim_buf_is_valid(state.buf) then
      pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
      state.buf = nil
    end
    return
  end

  local alive = term_alive(state.buf)
  if not alive then
    if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
      pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
    end
    state.buf = nil
  end

  local size = math.max(math.floor(vim.o.lines * state.height_fraction), 8)
  vim.cmd(("botright %dsplit"):format(size))

  if alive then
    vim.api.nvim_win_set_buf(0, state.buf)
  else
    vim.cmd("lcd " .. vim.fn.fnameescape(root))
    vim.cmd("terminal")
    state.buf = vim.api.nvim_get_current_buf()
    vim.bo[state.buf].buflisted = false

    vim.api.nvim_create_autocmd("TermClose", {
      buffer = state.buf,
      once = true,
      callback = function(ev)
        if state.buf == ev.buf then
          state.buf = nil
        end
      end,
    })
  end

  vim.wo.winfixheight = true
  vim.cmd.startinsert()
end

return M
