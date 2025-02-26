return {
  "echasnovski/mini.comment",
  event = "VeryLazy",
  vscode = true,
  opts = {
    options = {
      custom_commentstring = function()
        local ft = vim.bo.filetype
        if ft == "c" or ft == "c_sharp" or ft == "c#" then
          return "// %s"
        else
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end
      end,
    },
  },
}
