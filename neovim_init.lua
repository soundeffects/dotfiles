-- install lazy package manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- package setup
require("lazy").setup({
	spec = {
		{ "nvim-telescope/telescope.nvim", tag = "0.1.8", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "nvim-treesitter/nvim-treesitter", tag = "v0.10.0", lazy = false, build = ":TSUpdate" },
		{ "rose-pine/neovim", name = "rose-pine" },
		{ "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" } },
		{ "jiaoshijie/undotree" },
		{ "tpope/vim-fugitive" },
		{ "neovim/nvim-lspconfig" },
		{ "nvim-mini/mini.nvim", version = false },
		{ "Wansmer/treesj", dependencies = { "nvim-treesitter/nvim-treesitter" } },
		{ "godlygeek/tabular" },
		{ "rafamadriz/friendly-snippets" },
		{ "lewis6991/gitsigns.nvim" },
		{
			"nvim-telescope/telescope-frecency.nvim",
			dependencies = { "nvim-telescope/telescope.nvim" },
			version = "*",
		},
		{ "RRethy/vim-illuminate" },
		{ "lukas-reineke/indent-blankline.nvim" },
		{ "stevearc/conform.nvim" },
		{ "milanglacier/minuet-ai.nvim" },
	},
	install = { colorscheme = { "rose-pine" } },
	checker = { enabled = true },
})

require("nvim-treesitter.config").setup({
	ensure_installed = {
		"rust",
		"javascript",
		"python",
		"c",
		"zig",
		"toml",
		"markdown",
		"json",
		"json5",
		"html",
		"css",
		"lua",
		"typst",
		"wgsl",
	},
	sync_install = true,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

local harpoon = require("harpoon")
harpoon:setup()

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})

local animate = require("mini.animate")
animate.setup({
	cursor = {
		enable = false,
		-- timing = animate.gen_timing.linear({duration = 100, unit = 'total'}),
		-- path = animate.gen_path.angle()
	},
	scroll = {
		timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
	},
})

local minimap = require("mini.map")
minimap.setup()
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*.*",
	callback = minimap.open,
})
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "*.*",
	callback = minimap.close,
})

local snippets = require("mini.snippets")
snippets.setup({
	snippets = {
		snippets.gen_loader.from_lang(),
	},
})

local treesj = require("treesj")
treesj.setup({
	max_join_length = 1000,
})

require("mini.surround").setup()
require("mini.trailspace").setup()
require("mini.pairs").setup()
require("mini.icons").setup()
require("mini.notify").setup()
require("mini.starter").setup()
require("mini.completion").setup()
require("gitsigns").setup()
require("ibl").setup()
require("telescope").load_extension("frecency")

require("mini.comment").setup({
	mappings = {
		comment_line = "c",
		comment_visual = "c",
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

require("minuet").setup({
	virtualtext = {
		auto_trigger_ft = {},
		keymap = {
			accept = "<A-A>",
			accept_line = "<A-a>",
			accept_n_lines = "<A-z>",
			prev = "<A-[>",
			next = "<A-]>",
			dismiss = "<A-e>",
		},
	},
	provider = "openai_fim_compatible",
	n_completions = 1,
	context_window = 512,
	provider_options = {
		openai_fim_compatible = {
			api_key = "TERM",
			name = "Ollama",
			end_point = "http://localhost:11434/v1/completions",
			model = "qwen2.5-coder:7b",
			optional = {
				max_tokens = 56,
				top_p = 0.9,
			},
		},
	},
})

-- mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
vim.keymap.set("n", "da", "mzJ`z")
vim.keymap.set("n", "J", "}")
vim.keymap.set("n", "<C-j>", "<C-d>")
vim.keymap.set("n", "K", "{")
vim.keymap.set("n", "<C-K>", "<C-u>")
vim.keymap.set("n", "<C-y>", '"+y')
vim.keymap.set("n", "<C-Y>", '"+Y')
vim.keymap.set("n", "<C-d>", '"_d')
vim.keymap.set("n", "e", vim.diagnostic.goto_next)
vim.keymap.set("n", "o", "za")
vim.keymap.set("n", "O", "zR")
vim.keymap.set("n", "<C-o>", "zM")
vim.keymap.set("v", "<C-y>", '"+y')
vim.keymap.set("v", "<C-Y>", '"+Y')
vim.keymap.set("v", "<C-d>", '"_d')
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<C-j>", "<C-d>")
vim.keymap.set("v", "<C-K>", "<C-u>")
vim.keymap.set("v", "-", "=")
vim.keymap.set("x", "p", '"_dP')

telescope_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>f", function()
	local ok, result = pcall(telescope_builtin.git_files)
	if not ok then
		telescope_builtin.find_files()
	end
end, { desc = "Telescope search files, exclusively git files if possible" })

vim.keymap.set("n", "<leader>s", telescope_builtin.live_grep, { desc = "Telescope search files for grep string" })
vim.keymap.set(
	"n",
	"<leader>w",
	telescope_builtin.lsp_workspace_symbols,
	{ desc = "Telescope search symbols provided by the LSP for the current workspace" }
)

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end, { desc = "Add current file to harpoon menu" })

vim.keymap.set("n", "<leader>h", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Open harpoon menu" })

vim.keymap.set("n", "<leader>n", function()
	local previous_file = vim.fn.expand("%")
	harpoon:list():next()
	if previous_file == vim.fn.expand("%") then
		harpoon:list():select(1)
	end
end, { desc = "Switch to next item in harpoon menu, cycle around when reaching the end" })

vim.keymap.set("n", "<leader>u", function()
	require("undotree").toggle()
end, { desc = "Load and open undotree" })
vim.keymap.set("n", "<leader>g", vim.cmd.Git, { desc = "Open fugitive menu" })
vim.keymap.set("n", "t", treesj.toggle, { desc = "Split/join the block under cursor" })
vim.keymap.set("v", "t", ":Tabularize /")

-- lsp
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("luals")

-- settings
vim.cmd([[
colorscheme rose-pine
highlight NonText guibg   = none
highlight Normal ctermbg  = none
highlight NonText ctermbg = none
highlight Normal guibg    = none
]])
vim.opt.laststatus = 0
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.cc = "100"
vim.opt.scrolloff = 10
vim.wo.foldmethod = "expr"
vim.opt.foldlevel = 100
vim.opt.ruler = false

--[[
TODO
- Jumping plugin:
    - https://github.com/ggandor/leap.nvim
    - https://github.com/folke/flash.nvim
- Arrow keys remapping
- Mini completion remapping
- Consider a symbol map plugin
    - https://github.com/simrat39/symbols-outline.nvim
- Peruse the following resources for potential plugins:
    - https://github.com/nvim-telescope/telescope.nvim/wiki/Extensions
    - https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
- Make ai auto complete not require key presses to begin
--]]
