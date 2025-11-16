local vim_opts = require('core.utils').vim_opts

vim.opt.shortmess:append 'sIW'

vim_opts {
  opt = {
    number = true,
    mouse = 'a',
    showmode = false,
    breakindent = true,
    undofile = true,
    ignorecase = true,
    smartcase = true,
    signcolumn = 'no',
    colorcolumn = '100',
    updatetime = 100,
    timeoutlen = 300,
    splitright = true,
    splitbelow = true,
    list = true,
    listchars = { tab = '» ', trail = '·', nbsp = '␣' },
    inccommand = 'split',
    cursorline = true,
    cursorlineopt = 'number',
    scrolloff = 10,
    confirm = true,
    tabstop = 2,
    shiftwidth = 2,
    softtabstop = 2,
    expandtab = true,
    smartindent = true,
    autoindent = true,
    smarttab = true,
    numberwidth = 4,
    guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20',
    autowrite = true,
    termguicolors = true,
    sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions',
    completeopt = 'menu,menuone,noselect',
  },
  g = {},
}

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- vim: ts=2 sts=2 sw=2 et
