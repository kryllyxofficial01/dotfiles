-- Bootstrap lazy.nvim
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

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "ellisonleao/gruvbox.nvim",
            priority = 1000, -- load first
            config = function()
                require("gruvbox").setup({
                    contrast = "hard",         -- options: "hard", "soft", "medium"
                    transparent_mode = false,  -- true if you want transparent bg
                    overrides = {
                        -- Tree-sitter variables
                        ["@variable"] = { fg = "#83a598" },
                        -- Fallback (non-treesitter)
                        Identifier = { fg = "#83a598" },
                    },
                })
                vim.cmd.colorscheme("gruvbox")
            end,
        },
        {
            "nvim-tree/nvim-tree.lua",
            lazy = false,
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = function()
                require("nvim-tree").setup {
                    update_focused_file = {
                        enable = true,      -- enable tracking
                        update_cwd = true,  -- optionally update the tree's root to match the file's directory
                    },

                    git = {
                        enable = false,
                        ignore = false,
                    },

                    actions = {
                        open_file = {
                            quit_on_open = false,
                        },
                    },
                }

                require("nvim-treesitter.configs").setup({
                    ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query" }, -- parsers
                    highlight = {
                        enable = true,              -- enable highlighting
                        additional_vim_regex_highlighting = false,
                    },
                    indent = { enable = true },   -- better indentation
                })

                vim.api.nvim_create_autocmd("VimEnter", {
                    callback = function(data)
                        -- If a directory is opened, open nvim-tree
                        local directory = vim.fn.isdirectory(data.file) == 1

                        if directory then
                            require("nvim-tree.api").tree.open()
                            return
                        end

                        -- If it's a file, open the tree but keep the file visible
                        require("nvim-tree.api").tree.open()
                    end
                })
            end,
        },
        {
            "nvim-lualine/lualine.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            config = true
        },
        {
            'nvim-telescope/telescope.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' }
        },
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        { "lewis6991/gitsigns.nvim", config = true },
        { "neovim/nvim-lspconfig" },
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "L3MON4D3/LuaSnip",        -- for snippets
                "saadparwaiz1/cmp_luasnip" -- snippet completions
            },
            config = function()
                local cmp = require("cmp")
                cmp.setup({
                    snippet = {
                        expand = function(args)
                            require("luasnip").lsp_expand(args.body)
                        end,
                    },
                    mapping = cmp.mapping.preset.insert({
                        ["<C-Space>"] = cmp.mapping.complete(),
                        ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    }),
                    sources = cmp.config.sources({
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                        { name = "buffer" },
                    }),
                    completion = {
                        autocomplete = { cmp.TriggerEvent.TextChanged }, -- ✅ this makes it show while typing
                    },
                })
            end,
        },
        { "williamboman/mason.nvim", config = true },
        { "williamboman/mason-lspconfig.nvim" },
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "gruvbox" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})

-- LSP setup
local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Attach capabilities for nvim-cmp
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Setup clangd (Mason-installed)
lspconfig.clangd.setup({
    capabilities = capabilities,
    cmd = { vim.fn.stdpath("data") .. "/mason/bin/clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
})

vim.opt.wrap = false
vim.opt.number = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
