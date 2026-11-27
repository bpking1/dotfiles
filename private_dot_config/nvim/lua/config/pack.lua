local M = {}

local loaded = {}
local later_queue = {}
local later_scheduled = false

--- 将单个或多个 vim.pack 插件按需加入运行时并加载其启动脚本（幂等）
---@param names string|string[]
function M.packadd(names)
  local list = type(names) == "table" and names or { names }
  local opt_root = vim.fn.stdpath("data") .. "/site/pack/core/opt/"

  for _, name in ipairs(list) do
    if not loaded[name] then
      loaded[name] = true
      vim.cmd.packadd({ vim.fn.escape(name, " "), magic = { file = false } })

      -- 在 VimEnter 之后按需加载时，补执行插件的 after/plugin 脚本（与内置 vim.pack 保持一致）
      if vim.v.vim_did_enter == 1 then
        local after_paths = vim.fn.glob(opt_root .. name .. "/after/plugin/**/*.{vim,lua}", false, true)
        for _, path in ipairs(after_paths) do
          vim.cmd.source({ path, magic = { file = false } })
        end
      end
    end
  end
end

local function run_next_later()
  if #later_queue == 0 then
    later_scheduled = false
    return
  end

  local fn = table.remove(later_queue, 1)
  if #later_queue > 0 then
    vim.schedule(run_next_later)
  else
    later_scheduled = false
  end

  local ok, err = pcall(fn)
  if not ok then
    vim.notify("pack.later 执行失败: " .. tostring(err), vim.log.levels.ERROR)
  end
end

--- 将回调放入 FIFO 延迟队列，按事件循环 tick 顺序执行以保证首屏启动速度与模块依赖顺序
---@param fn function
function M.later(fn)
  table.insert(later_queue, fn)
  if not later_scheduled then
    later_scheduled = true
    vim.schedule(run_next_later)
  end
end

--- 注册原生 vim.pack 常用管理命令
function M.setup_commands()
  vim.api.nvim_create_user_command("PackUpdate", function()
    vim.pack.update()
  end, { desc = "更新所有 vim.pack 插件" })

  vim.api.nvim_create_user_command("PackClean", function()
    local inactive = vim.iter(vim.pack.get(nil, { info = false }))
      :filter(function(item)
        return not item.active
      end)
      :map(function(item)
        return item.spec.name
      end)
      :totable()

    if #inactive == 0 then
      vim.notify("没有可清理的未激活插件")
      return
    end

    vim.pack.del(inactive)
    vim.notify("已清理未激活插件: " .. table.concat(inactive, ", "))
  end, { desc = "删除未在配置中启用的 vim.pack 插件" })
end

return M
