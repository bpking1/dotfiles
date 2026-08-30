-- 设置 Leader 键为空格键 (必须在快捷键定义前设置)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

-- --- 基础显示设置 ---
opt.number = true           -- 显示行号
opt.relativenumber = true   -- 显示相对行号
opt.cursorline = true       -- 高亮当前行
opt.termguicolors = true    -- 启用真彩色支持
opt.signcolumn = "yes"      -- 保持最左侧标记列开启，防止抖动

-- --- 缩进与格式化 ---
opt.tabstop = 4             -- Tab键为4个空格
opt.shiftwidth = 4          -- 缩进为4个空格
opt.expandtab = true        -- 将Tab转换为空格
opt.smartindent = true      -- 智能缩进

-- --- 搜索设置 ---
opt.ignorecase = true       -- 搜索时忽略大小写
opt.smartcase = true        -- 搜索包含大写字母时区分大小写
opt.hlsearch = false        -- 默认不持久高亮上一次搜索结果

-- --- 系统与剪贴板 ---
opt.clipboard = "unnamedplus" -- 共享系统剪贴板
opt.mouse = "a"             -- 启用鼠标支持
opt.undofile = true         -- 开启持久撤销

-- --- 复制反馈 ---
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- --- netrw (内置文件树) 美化设置 ---
vim.g.netrw_banner = 0          -- 禁用顶部的帮助横幅 (Banner)
vim.g.netrw_liststyle = 3       -- 树状目录结构
vim.g.netrw_browse_split = 4    -- 在上一次光标所在的窗口打开选中的文件
vim.g.netrw_altv = 1            -- 分屏时垂直分割在右侧
vim.g.netrw_winsize = 25        -- 侧边栏文件树宽度占 25%
-- --- 代码折叠设置 (方案 A：使用缩进折叠，免除 Treesitter 编译依赖) ---
opt.foldmethod = "indent"       -- 基于缩进自动折叠
opt.foldlevel = 99              -- 打开文件时默认展开所有代码
opt.foldenable = true           -- 启用折叠功能

-- --- 外部修改自动实时重载与通知 ---
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("AutoReloadFiles", { clear = true }),
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("文件已被外部修改，已自动重载！", vim.log.levels.INFO, { title = "系统提示" })
  end,
})
