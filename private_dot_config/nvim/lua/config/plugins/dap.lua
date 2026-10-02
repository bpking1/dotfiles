local M = {}

function M.setup_lazy()
  local loaded = false

  local function load()
    if loaded then return require("dap") end
    loaded = true

    MiniDeps.add({ source = "mfussenegger/nvim-dap" })
    local dap = require("dap")
    dap.adapters.coreclr = {
      type = "executable",
      command = "netcoredbg",
      args = { "--interpreter=vscode" },
    }
    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          return vim.fn.input("DLL 绝对路径: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
      },
    }

    local map = vim.keymap.set
    map("n", "<F5>", dap.continue, { desc = "调试: 启动/继续" })
    map("n", "<F10>", dap.step_over, { desc = "调试: 单步跳过" })
    map("n", "<F11>", dap.step_into, { desc = "调试: 单步进入" })
    map("n", "<F9>", dap.toggle_breakpoint, { desc = "调试: 切换断点" })

    return dap
  end

  vim.keymap.set("n", "<F5>", function()
    load().continue()
  end, { desc = "调试: 启动/继续" })
end

return M
