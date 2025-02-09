return {
  {
    "neovim/nvim-lspconfig",

    opts = {
      servers = {
        gdscript = {
          name = "godot",
          cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
          filetypes = { "gd", "gdscript", "gdscript3" },
          root_dir = require("lspconfig.util").root_pattern("project.godot", ".git"),
          docs = {
            description = [[
            https://github.com/godotengine/godot

            Language server for GDScript, used by Godot Engine.
            ]],
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.godot = {
        type = "server",
        host = "127.0.0.1",
        port = 6006,
      }

      dap.configurations.gdscript = {
        {
          type = "godot",
          request = "launch",
          name = "Launch scene",
          project = "${workspaceFolder}",
          launch_scene = true,
          executable = "godot", -- Путь к Godot (или godot-headless)
          args = { "--path", "${workspaceFolder}" }, -- Аргументы для запуска Godot
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        gdscript = { "gdformat" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        gdscript = { "gdlint" },
      },
    },
  },
}
