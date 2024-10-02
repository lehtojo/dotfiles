vim.opt.termguicolors = true

-- Lazy
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

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Plugins
require("lazy").setup({
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
			end
		end,
	},
	{
		"neovim/nvim-lspconfig"
	},
	{
		"hrsh7th/cmp-nvim-lsp"
	},
	{
		"williamboman/mason.nvim"
	},
	{
		"hrsh7th/nvim-cmp"
	},
	{
		"linux-cultist/venv-selector.nvim",
		cmd = "VenvSelect",
		opts = function(_, opts)
			return vim.tbl_deep_extend("force", opts, {
				name = {
					"venv",
					".venv",
					"env",
					".env",
				},
			})
		end
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		opts = {
			mappings = {
				["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\`].", register = { cr = false } },
			},
		},
	},
	{ 'echasnovski/mini.comment', version = '*' },
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		}
	},
	{
		"lewis6991/gitsigns.nvim",
		event = {'BufNewFile', 'BufRead'},
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
		}
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					keymap = {
						accept = "<C-Right>",
						-- accept_word = "<C-Right>",
						next = "§",
						dismiss = "<ESC>"
					}
				}
			})
		end
	},
	{ "bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000 },
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
})

-- Autocompletion
local cmp = require('cmp')
cmp.setup {
	mapping = {
		["<C-N>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<Up>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<Down>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			else
				fallback()
			end
		end, { "i", "s" })
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	},
	auto_brackets = { "python" }
}

-- LSPs
local lspconfig = require('lspconfig')

-- Python
lspconfig.pyright.setup {}
lspconfig.ruff_lsp.setup {}

-- Typescript, Javascript
lspconfig.tsserver.setup {}

-- Lua
lspconfig.lua_ls.setup {}

-- Rust
lspconfig.rust_analyzer.setup {}

-- C#
local pid = vim.fn.getpid()

lspconfig.omnisharp.setup {
	cmd = { "OmniSharp", "--languageserver", "--hostPID", tostring(pid) }
}

-- Telescope
require('telescope').setup{ 
  defaults = { 
    file_ignore_patterns = { 
      "node_modules",
      "target"
    }
  }
}

-- Comment plugin
require('mini.comment').setup()

-- Statusline
require("lualine").setup{
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {''},
		lualine_y = {''},
		lualine_z = {''}
		-- lualine_x = {'encoding', 'fileformat', 'filetype'},
		-- lualine_y = {'progress'},
		-- lualine_z = {'location'}
	}
}

-- LSP package manager
require("mason").setup()

-- Signs
vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError", numhl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn", numhl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignHint", { text = " ", texthl = "DiagnosticSignHint", numhl = "DiagnosticSignHint" })
vim.fn.sign_define("DiagnosticSignInformation", { text = " ", texthl = "DiagnosticSignInformation", numhl = "DiagnosticSignInformation" })

-- Keybindings
vim.cmd([[nnoremap <C-p> :Telescope find_files<CR>]])
vim.cmd([[nnoremap <C-e> :Neotree toggle position=right<CR>]])
vim.cmd([[nnoremap <A-v> :vsplit<CR>]])

vim.cmd([[nnoremap <A-d> :colorscheme nightfly \| :set laststatus=0 \| :set noshowmode \| :set noruler<CR>]])
vim.cmd([[nnoremap <A-l> :colorscheme catppuccin<CR> \| :set laststatus=0 \| :set noshowmode \| :set noruler<CR>]])
vim.cmd([[nnoremap <A-t> :highlight normal guibg=transparent<CR> \| :highlight linenr guibg=transparent<CR> \| :highlight vertsplit guibg=transparent<CR> \| :highlight signcolumn guibg=transparent \| :set laststatus=0 \| :set noshowmode \| :set noruler<CR>]])
vim.cmd([[set laststatus=2]])

-- Code & Editor
vim.cmd([[set relativenumber]])
vim.cmd([[set number]])
vim.cmd([[set autoindent]])
vim.cmd([[set expandtab]])
vim.cmd([[set tabstop=2]])
vim.cmd([[set shiftwidth=2]])

-- Color scheme
require("catppuccin").setup({
	flavour = "latte",
	background = {
		light = "latte"
	}
})

vim.cmd.colorscheme "nightfly"
-- vim.cmd.colorscheme "catppuccin"

vim.cmd([[set laststatus=0]])
vim.cmd([[set noshowmode]])
vim.cmd([[set noruler]])
-- Fixes the issue where the sign column hides annoyingly after fixing errors
vim.cmd([[set signcolumn=yes]])

-- Removes the virtual '~' characters at the end of the file
vim.opt.fillchars = {eob = " "}

vim.cmd([[highlight normal guibg=transparent]])
vim.cmd([[highlight linenr guibg=transparent]])
vim.cmd([[highlight vertsplit guibg=transparent]])
vim.cmd([[highlight signcolumn guibg=transparent]])
vim.cmd([[set laststatus=0]])
vim.cmd([[set noshowmode ]])
vim.cmd([[set noruler]])
