-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- Настраиваем авто команду для включения орфографии в определенных типах файлов
local au = vim.api.nvim_create_autocmd

au({ "BufRead", "BufNewFile" }, {
  pattern = { "*.txt", "*.md", "*.rst" },
  callback = function()
    vim.opt.spell = true
    vim.opt.spelllang = { "ru", "en" }
    vim.opt.spell = true
  end,
})

au({ "FileType" }, {
  pattern = { "gd", "gdscript" },
  callback = function()
    vim.bo.filetype = "gdscript" -- Устанавливаем тип файла
  end,
})
