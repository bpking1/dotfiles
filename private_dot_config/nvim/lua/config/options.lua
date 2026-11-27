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
opt.laststatus = 3          -- 使用全局单状态栏

-- --- 窗口与编辑交互 ---
opt.splitbelow = true       -- 水平分屏默认在下方打开
opt.splitright = true       -- 垂直分屏默认在右侧打开
opt.splitkeep = "screen"    -- 分屏时保持当前屏幕视图位置稳定
opt.scrolloff = 10          -- 光标上下保留至少 10 行视野
opt.inccommand = "split"    -- 替换命令实时在分屏窗口预览效果
opt.confirm = true          -- 退出有未保存修改时弹确认而不是直接失败

-- --- 缩进与格式化 ---
opt.tabstop = 4             -- Tab键为4个空格
opt.shiftwidth = 4          -- 缩进为4个空格
opt.expandtab = true        -- 将Tab转换为空格
opt.smartindent = true      -- 智能缩进

-- --- 搜索设置 ---
opt.ignorecase = true       -- 搜索时忽略大小写
opt.smartcase = true        -- 搜索包含大写字母时区分大小写
opt.hlsearch = true         -- 搜索时高亮匹配项，配合内置 nohlsearch 包自动取消高亮
vim.cmd("packadd! nohlsearch")

-- --- 系统与剪贴板 ---
opt.mouse = "a"             -- 启用鼠标支持
opt.undofile = true         -- 开启持久撤销

-- 延迟到 UIEnter 再同步系统剪贴板，避免阻塞冷启动
vim.api.nvim_create_autocmd("UIEnter", {
  group = vim.api.nvim_create_augroup("DeferredClipboard", { clear = true }),
  once = true,
  callback = function()
    vim.o.clipboard = "unnamedplus"
  end,
})

-- --- 复制反馈 ---
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank({ timeout = 200 })
  end,
})

-- --- netrw (内置文件树) 美化设置 ---
vim.g.netrw_banner = 0          -- 禁用顶部的帮助横幅 (Banner)
vim.g.netrw_liststyle = 3       -- 树状目录结构
vim.g.netrw_browse_split = 4    -- 在上一次光标所在的窗口打开选中的文件
vim.g.netrw_altv = 1            -- 分屏时垂直分割在右侧
vim.g.netrw_winsize = 25        -- 侧边栏文件树宽度占 25%
-- --- 代码折叠设置（默认缩进折叠兜底，LSP 支持 foldingRange 时在 LspAttach 中自动切换为原生 LSP 折叠）---
opt.foldmethod = "indent"       -- 无 LSP 时基于缩进自动折叠
opt.foldlevel = 99              -- 打开文件时默认展开所有代码
opt.foldlevelstart = 99         -- 打开新缓冲区时默认全部展开
opt.foldenable = true           -- 启用折叠功能
opt.foldtext = ""               -- 使用 Neovim 原生透明语法高亮折叠行

-- --- 外部修改自动实时重载与通知 ---
local reload_group = vim.api.nvim_create_augroup("AutoReloadFiles", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = reload_group,
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = reload_group,
  callback = function()
    vim.notify("文件已被外部修改，已自动重载！", vim.log.levels.INFO, { title = "系统提示" })
  end,
})
