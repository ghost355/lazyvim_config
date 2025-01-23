return {
  "echasnovski/mini.comment",
  event = "VeryLazy",
  opts = {
    options = {
      custom_commentstring = function()
        local ft = vim.bo.filetype
        if ft == "c" then
          return "// %s"
        else
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end
      end,
    },
  },
}
