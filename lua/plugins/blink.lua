return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 100,
      },
      menu = {
        draw = {
          padding = 2,
          columns = { { "kind_icon" }, { "label", "label_description", "kind", gap = 1 } },
        },
      },
    },
    sources = {
      -- adding any nvim-cmp sources here will enable them
      -- with blink.compat
      default = { "lsp", "path", "snippets", "buffer", "codeium" },
    },
  },
}
