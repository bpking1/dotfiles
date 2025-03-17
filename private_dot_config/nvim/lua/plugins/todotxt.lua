return {
  "phrmendes/todotxt.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local todotxt = require("todotxt")
    todotxt.setup({
      todotxt = "/root/obsidian-vault/todo/todo.txt",
      donetxt = "/root/obsidian-vault/todo/done.txt",
    })
    -- 添加文件类型检测
    vim.filetype.add({
      extension = {
        ["txt"] = function(path, bufnr)
          if path:match("todo%.txt$") or path:match("done%.txt$") or path:match("/todo/.*%.txt$") then
            return "todotxt"
          end
          return "text"
        end,
      },
      pattern = {
        [".*/todo%.txt"] = "todotxt",
        [".*/done%.txt"] = "todotxt",
        [".*/todo/.*%.txt"] = "todotxt",
      },
    })
    -- keyband
    local opts = { noremap = true }
    opts.desc = "todo.txt: toggle task state"
    vim.keymap.set("n", "gx", todotxt.toggle_todo_state, opts)

    opts.desc = "todo.txt: cycle priority"
    vim.keymap.set("n", "gp", todotxt.cycle_priority, opts)

    opts.desc = "Open"
    vim.keymap.set("n", "<leader>tt", todotxt.open_todo_file, opts)

    opts.desc = "Sort"
    vim.keymap.set("n", "<leader>ts", todotxt.sort_tasks, opts)

    opts.desc = "Sort by (priority)"
    vim.keymap.set("n", "<leader>tP", todotxt.sort_tasks_by_priority, opts)

    opts.desc = "Sort by @context"
    vim.keymap.set("n", "<leader>tc", todotxt.sort_tasks_by_context, opts)

    opts.desc = "Sort by +project"
    vim.keymap.set("n", "<leader>tp", todotxt.sort_tasks_by_project, opts)

    opts.desc = "Sort by due:date"
    vim.keymap.set("n", "<leader>tD", todotxt.sort_tasks_by_due_date, opts)

    opts.desc = "Move to done.txt"
    vim.keymap.set("n", "<leader>td", todotxt.move_done_tasks, opts)
  end,
}
