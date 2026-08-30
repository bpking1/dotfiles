local map = vim.keymap.set

-- 1. 窗口间快速跳转 (Ctrl + h/j/k/l)
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- 2. 文本整行上下移动 (Alt + j/k)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- 3. 标签页/缓冲区快速切换 (Shift + h/l)
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete Buffer" })

-- 4. 其它便利快捷
map("v", "<", "<gv", { desc = "Indent left and keep selection" })
map("v", ">", ">gv", { desc = "Indent right and keep selection" })
-- 保存与关闭窗口
map({ "n", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save file" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save file and exit insert mode" })
map("n", "<leader>q", "<cmd>confirm q<cr>", { desc = "Quit window" })

-- 5. 个性化行首/行尾快速跳转 (Emacs 风格)
local map_opt = { noremap = true, silent = true }
map({ "n", "v", "o" }, "<C-a>", "^", map_opt)
map({ "n", "v", "o" }, "<C-e>", "<End>", map_opt)
map("i", "<C-a>", "<Esc>I", map_opt)
map("i", "<C-e>", "<Esc>A", map_opt)

-- 6. 窗口分割与大小调整 (与 LazyVim 一致)
-- 窗口分割
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Split Window Right" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "Split Window Below" })
-- Ctrl + 方向键 调整窗口大小
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })


-- 7. Ctrl + \ 快捷键：在下方打开/切换终端 (Toggle Terminal)
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  -- 如果终端窗口当前是打开且有效的，就关闭它
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
  else
    -- 在下方打开 12 行高度的分割窗口
    vim.cmd("botright 12sp")
    term_win = vim.api.nvim_get_current_win()
    
    -- 如果之前的终端 Buffer 还在，就复用它；否则新建一个
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      vim.api.nvim_win_set_buf(term_win, term_buf)
    else
      vim.cmd("terminal")
      term_buf = vim.api.nvim_get_current_buf()
      
      -- 监听终端关闭事件，自动清理 Buffer 引用
      vim.api.nvim_create_autocmd("TermClose", {
        buffer = term_buf,
        once = true,
        callback = function()
          term_buf = nil
          term_win = nil
        end,
      })
    end
    -- 自动进入终端输入模式
    vim.cmd("startinsert")
  end
end

-- 支持在 Normal 模式和 Terminal 模式下通过 Ctrl + \ 切换终端
map({ "n", "t" }, "<C-_>", toggle_terminal, { desc = "Toggle Terminal", silent = true })
