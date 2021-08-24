local cmd = vim.cmd -- execute vim commands
local fn = vim.fn -- call vim functions
local set = vim.opt
local execute = vim.api.nvim_command

local U = require 'utils'
local map = U.map
local nmap = U.nmap
local imap = U.imap
local vmap = U.vmap

-- Bootstrap packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

local packer = require 'packer'
local use = packer.use

packer.startup(function ()
  use { 'wbthomason/packer.nvim', opt = true }

 use {
    'kyazdani42/nvim-tree.lua',
    opt = true,
    cmd = { 'NvimTreeOpen', 'NvimTreeToggle' },
    setup = require('nv-tree').setup,
    config = require('nv-tree').config,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = require('tree-sitter').config
  }

  use {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    config = require('_autopairs').config
  }

  use {
    'nvim-telescope/telescope.nvim',
    event = { 'VimEnter' },
    setup = require('nv-telescope').setup,
    config = require('nv-telescope').config,
    requires = { {'nvim-lua/plenary.nvim'} },
  }

  use {
    "neovim/nvim-lspconfig",
    config = require("lsp"),
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
  }

  use {
    'jose-elias-alvarez/nvim-lsp-ts-utils',
  }

  use {
    'windwp/nvim-ts-autotag',
    config = function() require('nvim-ts-autotag').setup() end
  }

  use {
    'hrsh7th/nvim-compe',
    config = require('nv-compe').config,
    event = { 'InsertEnter' },
    -- after = 'LuaSnip',
  }

  use {
    'folke/trouble.nvim',
    config = require('nv-trouble').config,
    requires = "kyazdani42/nvim-web-devicons",
  }

  use {
    'lewis6991/gitsigns.nvim',
    config = require('nv-gitsigns').config,
    event = { "BufReadPre", "BufNewFile" },
    requires = { "nvim-lua/plenary.nvim" },
  }

  use 'tpope/vim-eunuch'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'

  use 'shaunsingh/moonlight.nvim'

  use 'bluz71/vim-moonfly-colors'

  use 'b3nj5m1n/kommentary'

  use {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete', 'Bwipeout' },
  }
end)

local executable = function(e)
    return fn.executable(e) > 0
end


vim.g.mapleader = ' '

-- PLUGIN: b3nj5m1n / kommentary {{{
  vim.g.kommentary_create_default_mappings = false
  vim.api.nvim_set_keymap("n", "<leader>cc", "<Plug>kommentary_line_default", {})
  vim.api.nvim_set_keymap("n", "<leader>c", "<Plug>kommentary_motion_default", {})
  vim.api.nvim_set_keymap("v", "<leader>c", "<Plug>kommentary_visual_default<C-c>", {})
-- }}}

-----------------------------------------------------------------------------//
-- Indentation {{{1
-----------------------------------------------------------------------------//
set.expandtab = true -- Use spaces instead of tabs
set.shiftwidth = 2 -- Size of an indent
set.tabstop = 2 -- Number of spaces tabs count for
set.softtabstop = 2
set.smartindent = true -- Insert indents automatically
set.shiftround = true -- Round indent
set.joinspaces = false -- No double spaces with join after a dot

-----------------------------------------------------------------------------//
-- Display {{{1
-----------------------------------------------------------------------------//
set.number = true -- Display line number
set.relativenumber = true -- Relative line numbers
set.numberwidth = 2
set.signcolumn = 'yes:1' -- 'auto:1-2'
set.colorcolumn = '81'

set.wrap = true
set.linebreak = true -- wrap, but on words, not randomly
-- set.textwidth = 80
set.synmaxcol = 1024 -- don't syntax highlight long lines
vim.g.vimsyn_embed = 'lPr' -- allow embedded syntax highlighting for lua, python, ruby
set.showmode = false
set.lazyredraw = true
set.emoji = false -- turn off as they are treated as double width characters
set.list = true -- show invisible characters

set.listchars = {
    eol = ' ',
    tab = '→ ',
    extends = '…',
    precedes = '…',
    trail = '·',
}
set.shortmess:append 'I' -- disable :intro startup screen

-----------------------------------------------------------------------------//
-- Title {{{1
-----------------------------------------------------------------------------//
set.titlestring = '❐ %t'
set.titleold = '%{fnamemodify(getcwd(), ":t")}'
set.title = true
set.titlelen = 70

-----------------------------------------------------------------------------//
-- Folds {{{1
-----------------------------------------------------------------------------//
-- TODO: Understand these settings
set.foldtext = 'folds#render()'
set.foldopen:append { 'search' }
set.foldlevelstart = 10
set.foldmethod = 'syntax'
-- set.foldmethod = 'expr'
-- set.foldexpr='nvim_treesitter#foldexpr()'

-----------------------------------------------------------------------------//
-- Backup {{{1
-----------------------------------------------------------------------------//
set.swapfile = false
set.backup = false
set.writebackup = false
set.undofile = true -- Save undo history
set.confirm = true -- prompt to save before destructive actions
-- set.updatetime = 1000 -- cursor update and swapfile write time. Do not set to 0

-----------------------------------------------------------------------------//
-- Search {{{1
-----------------------------------------------------------------------------//
set.ignorecase = true -- Ignore case
set.smartcase = true -- Don't ignore case with capitals
set.wrapscan = true -- Search wraps at end of file
set.scrolloff = 5 -- Lines of context
set.sidescrolloff = 8 -- Columns of context
set.showmatch = true
cmd [[set nohlsearch]]

-- Use faster grep alternatives if possible
if executable 'rg' then
    set.grepprg =
        [[rg --hidden --glob "!.git" --no-heading --smart-case --vimgrep --follow $*]]
    set.grepformat:prepend { '%f:%l:%c:%m' }
end

-----------------------------------------------------------------------------//
-- window splitting and buffers {{{1
-----------------------------------------------------------------------------//
set.hidden = true -- Enable modified buffers in background
set.splitbelow = true -- Put new windows below current
set.splitright = true -- Put new windows right of current
set.fillchars = {
    vert = '│',
    fold = ' ',
    diff = '-', -- alternatives: ⣿ ░
    msgsep = '‾',
    foldopen = '▾',
    foldsep = '│',
    foldclose = '▸',
}

-----------------------------------------------------------------------------//
-- Terminal {{{1
-----------------------------------------------------------------------------//
-- Open a terminal pane on the right using :Term
-- cmd [[command Term :botright vsplit term://$SHELL]]

-- Terminal visual tweaks
-- Enter insert mode when switching to terminal
-- Close terminal buffer on process exit
cmd [[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufEnter,BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
    autocmd TermClose term://* call nvim_input('<CR>')
    autocmd TermClose * call feedkeys("i")
]]


-----------------------------------------------------------------------------//
-- Mouse {{{1
-----------------------------------------------------------------------------//
set.mouse = 'a'

-----------------------------------------------------------------------------//
-- Netrw {{{1
-----------------------------------------------------------------------------//
-- do not display info on the top of window
vim.g.netrw_banner = 0

-----------------------------------------------------------------------------//
-- Colorscheme {{{1
-----------------------------------------------------------------------------//
set.termguicolors = true
vim.cmd [[ colorscheme moonfly ]]

-----------------------------------------------------------------------------//
-- Keymaps {{{1
-----------------------------------------------------------------------------//
-- unmap any functionality tied to space
nmap('<Space>', '<NOP>')

-- Toggle highlighting
nmap('<leader><leader>h', '<cmd>set hlsearch!<CR>')

imap('jk', '<Esc>')
imap('kj', '<Esc>')

-- Better split navigation
nmap('<C-h>', '<C-w>h')
nmap('<C-j>', '<C-w>j')
nmap('<C-k>', '<C-w>k')
nmap('<C-l>', '<C-w>l')

nmap('<Leader>o', 'o<Esc>k')
nmap('<Leader>O', 'O<Esc>j')

-- Better indenting
vmap('<', '<gv')
vmap('>', '>gv')

-- Buffer management
nmap('<Tab>', '<cmd>bnext<CR>')
nmap('<S-Tab>', '<cmd>bprev<CR>')

nmap('<Leader>bk', '<cmd>Bdelete<CR>')

-- Exit terminal using easier keybindings
U.map('t', 'jk', '<C-\\><C-n>')

-- Source lua.init
nmap('<leader>si', '<cmd>luafile ~/.config/nvim/init.lua<CR>')
-- Source current lua file
nmap('<leader>so', '<cmd>luafile %<CR>')

-- Auto closing brackets
--[[
imap('(;', '(<CR>);<C-c>O')
imap('{;', '{<CR>};<C-c>O')
imap('{;', '{<CR>};<C-c>O')
imap('[;', '[<CR>];<C-c>O')
imap('[;', '[<CR>];<C-c>O')

imap('{<Space>', '{<Space><Space>}<C-c>hi')
imap('[<Space>', '[<Space><Space>]<C-c>hi')

imap('{<CR>', '{<CR>}<C-c>O')
imap('(<CR>', '(<CR>)<C-c>O')
]]

-- Line bubbling
U.map('x', 'J', ':m \'>+1<CR>gv-gv')
U.map('x', 'K', ':m \'<-2<CR>gv-gv')
imap('<C-j>', '<cmd>move .+1<CR><esc>==a')
imap('<C-k>', '<cmd>move .-2<CR><esc>==a')
nmap('<leader>j', '<cmd>move .+1<CR>==')
nmap('<leader>k', '<cmd>move .-2<CR>==')

-- Close readonly buffers with q
nmap('q', '&readonly ? \':close!<CR>\' : \'q\'', { expr = true, noremap = true })

map('', 'Q', '') -- disable Q for ex mode
map('', 'q:', '') -- disable Q for ex mode
-- U.map('n', 'x', '"_x') --delete char without yank
-- U.map('x', 'x', '"_x') -- delete visual selection without yank
--
nmap('Y', 'y$', { noremap = true })

imap(',', ',<C-g>u')
imap('.', '.<C-g>u')
imap('!', '!<C-g>u')
imap('(', '(<C-g>u')
-----------------------------------------------------------------------------//
-- }}}1
-----------------------------------------------------------------------------//
