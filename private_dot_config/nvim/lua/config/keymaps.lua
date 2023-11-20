-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- https://github.com/yaocccc/nvim/blob/master/lua/keymap.lua
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- 注意 c-x要留给tmux用,alt要留给hyprwm,ctrl+shift一部分给kitty

-- 保存本地变量
local map = vim.api.nvim_set_keymap
local opt = { noremap = true }

-- 默认<c-a>是数字加一,<c-e>是屏幕移动一行
-- "o"指的是衔接命令的时候,eg: 5d
map("n", "<c-a>", "^", opt)
map("n", "<c-e>", "<End>", opt)
map("v", "<c-a>", "^", opt)
map("v", "<c-e>", "<End>", opt)
map("o", "<c-a>", "^", opt)
map("o", "<c-e>", "<End>", opt)
map("i", "<c-a>", "<Esc>I", opt)
map("i", "<c-e>", "<Esc>A", opt)
