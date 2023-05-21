-- completeopt is used to manage code suggestions
-- menuone: show popup even when there is only one suggestion
-- noinsert: Only insert text when selection is confirmed
-- noselect: force us to select one from the suggestions
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert', 'preview'}
-- shortmess is used to avoid excessive messages
vim.opt.shortmess = vim.opt.shortmess + { c = true}

local cmp = require('cmp')
cmp.setup({ 
	-- Configurations will go here
})

-- sources are the installed sources that can be used for code suggestions
sources = {
	{ name = 'path' },
	{ name = 'nvim_lsp', keyword_length = 3 },
	{ name = 'nvim_lsp_signature_help'}, 
	{ name = 'nvim_lua', keyword_length = 2},
	{ name = 'buffer', keyword_length = 2 },
	{ name = 'vsnip', keyword_length = 2 },
}
