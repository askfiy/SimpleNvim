vim.deprecate = function() end

vim.g.mapleader = " "

vim.opt.ruler = false
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.cmdheight = 1
vim.opt.signcolumn = "yes:1"
vim.opt.completeopt = "menuone,noselect"
vim.opt.pumheight = 10
vim.opt.updatetime = 500
vim.opt.timeoutlen = 500
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.numberwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.scrolloff = 21
vim.opt.smoothscroll = true
vim.opt.mouse = "a"
vim.opt.list = true
vim.opt.spell = false
vim.opt.spelllang = "en_us,cjk"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.filetype = "plugin"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"
vim.opt.foldenable = true
vim.opt.clipboard = "unnamedplus"
vim.opt.smartindent = true
vim.opt.iskeyword = "@,48-57,_,192-255"
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.fillchars = "eob: ,fold: ,foldopen: ,foldsep: ,foldclose:"
vim.opt.fileencodings = "ucs-bom,utf-8,gbk,big5,gb18030,latin1"
vim.opt.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,globals"
vim.opt.showtabline = 2

vim.opt.undofile = true

vim.opt.listchars:append({
    tab = "⇥ ",
    -- tab = "  ",
    -- leadmultispace = "┊ ",
    leadmultispace = "  ",
    trail = "␣",
    nbsp = "⍽",
    eol = "↴",
    -- eol = " ",
    space = "⋅",
    -- space = " ",
})

vim.opt.diffopt:append("vertical")
vim.opt.shortmess:append("sI")
vim.opt.whichwrap:append("<>[]hl")
