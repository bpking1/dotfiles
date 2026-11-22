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


-- 7. <C-_> 快捷键（多数终端对应 Ctrl + /）：在下方打开/切换持久化项目终端
map({ "n", "t" }, "<C-_>", function()
  require("config.terminal").toggle()
end, { desc = "Toggle Terminal", silent = true })
