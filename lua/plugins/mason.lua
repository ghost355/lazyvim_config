return {
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:Crashdummyy/mason-registry",
        "github:mason-org/mason-registry",
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      max_concurrent_installers = 4,
    },
  },
}
