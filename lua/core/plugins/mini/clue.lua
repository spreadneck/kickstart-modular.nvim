local M = {}

local function build_triggers()
  local trigger_specs = {
    { modes = { 'n', 'x' }, keys = '<Leader>' },
    { modes = { 'i' }, keys = '<C-x>' },
    { modes = { 'n', 'x' }, keys = 'g' },
    { modes = { 'n', 'x' }, keys = "'" },
    { modes = { 'n', 'x' }, keys = '`' },
    { modes = { 'n', 'x' }, keys = '"' },
    { modes = { 'i', 'c' }, keys = '<C-r>' },
    { modes = { 'n' }, keys = '<C-w>' },
    { modes = { 'n', 'x' }, keys = 'z' },
    { modes = { 'n', 'x' }, keys = '[' },
    { modes = { 'n', 'x' }, keys = ']' },
  }
  local triggers = {}
  for _, spec in ipairs(trigger_specs) do
    for _, mode in ipairs(spec.modes) do
      triggers[#triggers + 1] = { mode = mode, keys = spec.keys }
    end
  end
  return triggers
end

local function custom_clues()
  local sections = {
    { mode = 'n', keys = '<Leader>s', desc = '[S]earch' },
    { mode = 'n', keys = '<Leader>t', desc = '[T]oggle' },
    { mode = 'n', keys = '<Leader>h', desc = 'Git [H]unk' },
    { mode = 'x', keys = '<Leader>h', desc = 'Git [H]unk' },
  }
  return sections
end

function M.setup()
  local miniclue = require 'mini.clue'
  miniclue.setup {
    window = {
      -- Small delay keeps the window from flashing for accidental key presses.
      delay = 200,
      config = {
        anchor = 'SW',
        row = 'auto',
        col = 'auto',
      },
    },
    triggers = build_triggers(),
    clues = {
      miniclue.gen_clues.square_brackets(),
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      custom_clues(),
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

return M
-- vim: ts=2 sts=2 sw=2 et
