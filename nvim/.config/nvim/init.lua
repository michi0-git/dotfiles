vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { 'nvim-telescope/telescope.nvim', tag = '0.1.5', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-tree/nvim-tree.lua', lazy = false, dependencies = { 'nvim-tree/nvim-web-devicons' }, config = function() require("nvim-tree").setup {} end },
  { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' }, config = function() require('lualine').setup { options = { theme = 'dracula' } } end },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "lua", "python", "javascript", "typescript", "vim", "vimdoc", "bash" },
            highlight = { enable = true },
            indent = { enable = true },
        },
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    end,
  },
  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
    config = function()
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "pyright" }, 
        })
        -- ここで各LSPを有効化する設定を書く（後述）
    end,
  },
})

vim.cmd.colorscheme "catppuccin"
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

