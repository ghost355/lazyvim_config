return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  { "marko-cerovac/material.nvim" },
  { "rmehri01/onenord.nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox",
    },
  },
}
