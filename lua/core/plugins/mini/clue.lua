return function()
  local miniclue = require 'mini.clue'
  miniclue.setup {
    window = {
      delay = 200,
      config = {
        anchor = 'SW',
        row = 'auto',
        col = 'auto',
      },
    },
    triggers = {
      -- Leader
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },
      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },
      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },
      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },
      -- Window commands
      { mode = 'n', keys = '<C-w>' },
      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
      -- Brackets
      { mode = 'n', keys = '[' },
      { mode = 'n', keys = ']' },
      { mode = 'x', keys = '[' },
      { mode = 'x', keys = ']' },
    },
    clues = {
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      {
        { mode = 'n', keys = '<Leader>s', desc = '[S]earch' },
        { mode = 'n', keys = '<Leader>t', desc = '[T]oggle' },
        { mode = 'n', keys = '<Leader>h', desc = 'Git [H]unk' },
        { mode = 'x', keys = '<Leader>h', desc = 'Git [H]unk' },
      },
    },
  }

  local clue_group = vim.api.nvim_create_augroup('mini-clue-triggers', { clear = true })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = clue_group,
    callback = function(args)
      vim.schedule(function() miniclue.ensure_buf_triggers(args.buf) end)
    end,
  })
end
