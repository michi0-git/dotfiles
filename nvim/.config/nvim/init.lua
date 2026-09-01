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

        local lspconfig = require("lspconfig")
        lspconfig.lua_ls.setup({})
        lspconfig.pyright.setup({
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "workspace",
                    },
                },
            },
        })
    end,
  },
})

vim.cmd.colorscheme "catppuccin"
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { silent = true })
vim.keymap.set('n', '<leader>t', ':botright spl | resize 12 | terminal<CR>i', { silent = true })    -- space + t
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })  -- space + e
vim.keymap.set('n', '<C-h>', '<C-w>h', { silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { silent = true })
vim.keymap.set('n', '<leader>q', ':bdelete<CR>', { silent = true })
vim.keymap.set('n', '<leader>w', ':w<CR>', { silent = true })

