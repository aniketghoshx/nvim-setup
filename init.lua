vim.g.mapleader = ' '

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"

local servers = { "clangd", "pyright", "gopls", "jdtls"}

vim.pack.add({
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("nvim-treesitter").setup({})

require("nvim-treesitter").install({
    "c",
    "cpp",
    "go",
    "lua",
    "java"
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { "c", "cpp", "go", "lua", "java" },
    callback = function() vim.treesitter.start() end,
})

require("mason").setup()

require("gitsigns").setup({
		signs = {
				add = {text='+'},
				change = {text='~'},
				delete = {text='_'},
				topdelete = {text='-'},
				changedelete = {text='~'},
		}
})

-- Git
vim.keymap.set("n", "[h", function()
    require("gitsigns").next_hunk()
end, { desc = "Next Git hunk" })

vim.keymap.set("n", "]h", function()
    require("gitsigns").prev_hunk()
end, { desc = "Previous Git hunk" })

vim.keymap.set("n", "<leader>hs", function()
    require("gitsigns").stage_hunk()
end, { desc = "Stage hunk" })

vim.keymap.set("n", "<leader>hu", function()
    require("gitsigns").undo_stage_hunk()
end, { desc = "Unstage hunk" })

vim.keymap.set("n", "<leader>hr", function()
    require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })

vim.keymap.set("n", "<leader>hp", function()
    require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })

vim.keymap.set("n", "<leader>hb", function()
    require("gitsigns").blame_line()
end, { desc = "Blame line" })

require("trouble").setup()

require("oil").setup({
		columns = {
				"permissions",
				"icon"
		},
		view_options = {
				show_hidden = true
		}
})


require("blink.cmp").setup({
        keymap = {
            preset = 'default',
            ['<Tab>'] = {
              function(cmp)
                if cmp.snippet_active() then return cmp.accept()
                else return cmp.select_and_accept() end
              end,
              'snippet_forward',
              'fallback'
            },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' }, 
        },
		fuzzy = { implementation = 'prefer_rust' }
})

require("mini.pick").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.statusline").setup()

vim.lsp.config('*', {
    capabilities = require("blink.cmp").get_lsp_capabilities(),
})
for _, server in ipairs(servers) do
		vim.lsp.enable(server)
end

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })

vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

vim.keymap.set("n", "<leader>lh", vim.lsp.buf.signature_help, { desc = "Signature help" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line diagnostics" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { desc = "Format" })

local function pack_clean()
		local active_plugins = {} 
		local unused_plugins = {}

		for _, plugin in ipairs(vim.pack.get()) do
				active_plugins[plugin.spec.name] = plugin.active
		end

		for _, plugin in ipairs(vim.pack.get()) do
				if not active_plugins[plugin.spec.name] then
						table.insert(unused_plugins, plugin.spec.name)
				end
		end

		if #unused_plugins == 0 then
				print("No unused plugins.")
				return
		end

		local choice = vim.fn.confirm("Remove unused plugins","&Yes\n&No", 2)
		if choice == 1 then
				vim.pack.del(unused_plugins)
		end
end


vim.cmd.colorscheme("tokyonight-night")

vim.keymap.set("n", "<leader>e", ":Oil<CR>")
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>")
vim.keymap.set("n", "<leader>b", ":Pick buffers<CR>")
vim.keymap.set("n", "<leader>q", ":Trouble diagnostics toggle<CR>")

-- Buffers
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

vim.keymap.set("i", "<C-c>", "<Esc>")


vim.keymap.set("n", "<leader>pc", pack_clean)

local autocmd = vim.api.nvim_create_autocmd
autocmd('TextYankPost', {
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "=ap", "ma=ap'a")


vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>gcc", "<cmd>!g++ %<CR>", { silent = true })
