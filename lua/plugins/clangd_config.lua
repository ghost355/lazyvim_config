return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          cmd = {
            "clangd",
            "--fallback-style=LLVM",
          },
          settings = {
            -- Кастомные настройки форматирования
            format = {
              indentWidth = 4,
              columnLimit = 100,
              basedOnStyle = "LLVM",
            },
          },
        },
      },
    },
  },
}
