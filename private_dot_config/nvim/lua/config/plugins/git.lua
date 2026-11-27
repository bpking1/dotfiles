local M = {}

--- 注册懒加载的 Diffview 与原生异步 :GitBlameLine 命令
function M.setup_lazy()
  local loaded = false

  local function load()
    if loaded then return end
    loaded = true

    require("config.pack").packadd({ "nvim-web-devicons", "diffview.nvim" })
    require("diffview").setup({})
  end

  local function toggle_diffview()
    load()
    if require("diffview.lib").get_current_view() then
      vim.cmd("DiffviewClose")
    else
      vim.cmd("DiffviewOpen")
    end
  end

  -- 代理常见用户命令，手动输入 :DiffviewOpen / :DiffviewFileHistory 时也能触发按需加载
  for _, cmd_name in ipairs({ "DiffviewOpen", "DiffviewFileHistory" }) do
    vim.api.nvim_create_user_command(cmd_name, function(opts)
      pcall(vim.api.nvim_del_user_command, "DiffviewOpen")
      pcall(vim.api.nvim_del_user_command, "DiffviewFileHistory")
      load()
      local suffix = (opts.args and opts.args ~= "") and (" " .. opts.args) or ""
      vim.cmd(cmd_name .. suffix)
    end, { nargs = "*", desc = "按需加载 Diffview 并执行 " .. cmd_name })
  end

  local map = vim.keymap.set
  map("n", "<leader>gd", toggle_diffview, { desc = "Git: Toggle Diffview" })
  map("n", "<leader>gh", function()
    load()
    vim.cmd("DiffviewFileHistory %")
  end, { desc = "Git: File History (Current)" })
  map("n", "<leader>gH", function()
    load()
    vim.cmd("DiffviewFileHistory")
  end, { desc = "Git: File History (Repo)" })
  map("n", "<leader>gb", "<cmd>GitBlameLine<cr>", { desc = "Git: Blame Line" })

  vim.api.nvim_create_user_command("GitBlameLine", function()
    local filename = vim.api.nvim_buf_get_name(0)
    if filename == "" or vim.bo.buftype ~= "" then
      vim.notify("当前缓冲区不是有效文件", vim.log.levels.WARN)
      return
    end
    local line = vim.api.nvim_win_get_cursor(0)[1]
    local dir = vim.fs.dirname(filename)
    vim.system({ "git", "-C", dir, "blame", "-L", line .. ",+1", "--", filename }, { text = true }, function(res)
      vim.schedule(function()
        if res.code ~= 0 then
          local err = vim.trim(res.stderr or "")
          vim.notify("GitBlameLine 失败: " .. (err ~= "" and err or "未知错误"), vim.log.levels.WARN)
          return
        end
        local out = vim.trim(res.stdout or "")
        vim.notify(out ~= "" and out or "无 blame 信息", vim.log.levels.INFO, { title = "Git Blame" })
      end)
    end)
  end, { desc = "显示当前行的 Git Blame 信息" })
end

return M
