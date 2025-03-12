return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = false,
      },
    },
  },

  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = function(_, opts)
      return {
        code = {
          sign = false,
          width = "block",
          right_pad = 1,
        },
      }
    end,
  },
}
