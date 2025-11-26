local M = {}
local utils = require 'core.utils'

local function zk_insert_link()
  local util = require 'zk.util'
  local zk = require 'zk'
  local api = require 'zk.api'

  local ok_loc, location = pcall(util.get_lsp_location_from_selection)
  local ok_text, selected_text = pcall(util.get_selected_text)

  if not ok_loc or not ok_text or not location or not selected_text or selected_text == '' then
    ok_loc, location = pcall(util.get_lsp_location_from_caret)
    selected_text = nil
  end

  zk.pick_notes({}, { title = 'Zk Insert link', multi_select = false }, function(note)
    if not note then
      return
    end
    local link_opts = {}
    if selected_text and selected_text ~= '' then
      link_opts.title = selected_text
    end
    api.link(note.path, location, nil, link_opts, function(err, res)
      if not res then
        error(err)
      end
    end)
  end)
end

local function zk_command(name, opts)
  return utils.with_prompt(function()
    local cmd = require('zk.commands').get(name)
    local params = nil
    if type(opts) == 'function' then
      params = opts()
    elseif opts then
      params = vim.deepcopy(opts)
    end
    cmd(params)
  end)
end

local function zk_new(opts_fn)
  return function()
    local zk = require 'zk'
    local opts = opts_fn and opts_fn() or {}
    zk.new(opts)
  end
end

local function zk_keymaps()
  local defs = {
    {
      lhs = '<leader>zn',
      desc = 'Zk: New note',
      handler = utils.with_prompt(function()
        utils.prompt_input {
          prompt = 'Title',
          on_submit = function(title)
            local params = {}
            if title and title ~= '' then
              params.title = title
            end
            require('zk.commands').get('ZkNew')(params)
          end,
          on_cancel = function() end,
        }
      end),
    },
    {
      lhs = '<leader>zd',
      desc = 'Zk: Daily note',
      handler = zk_new(function() return { dir = 'journal' } end),
    },
    { lhs = '<leader>zN', mode = 'v', desc = 'Zk: New note from title selection', handler = zk_command 'ZkNewFromTitleSelection' },
    { lhs = '<leader>zo', desc = 'Zk: Orphans', handler = zk_command 'ZkOrphans' },
    { lhs = '<leader>zs', desc = 'Zk: Search notes', handler = zk_command 'ZkNotes' },
    { lhs = '<leader>zw', desc = 'Zk: Work notes (last 3 days)', handler = zk_command('ZkWorkNotes') },
    { lhs = '<leader>zb', desc = 'Zk: Backlinks', handler = zk_command 'ZkBacklinks' },
    { lhs = '<leader>zl', desc = 'Zk: Insert link', handler = utils.with_prompt(zk_insert_link) },
    {
      lhs = '<leader>zL',
      desc = 'Zk: Insert new linked note',
      handler = zk_command('ZkNew', function() return { link = true } end),
    },
  }
  local keys = {}
  for _, def in ipairs(defs) do
    keys[#keys + 1] = {
      def.lhs,
      def.handler,
      desc = def.desc,
      mode = def.mode,
    }
  end
  return keys
end

function M.config()
  return {
    {
      'zk-org/zk-nvim',
      ft = 'markdown',
      keys = zk_keymaps(),
      config = function()
        local zk = require 'zk'
        local commands = require 'zk.commands'

        zk.setup {
          picker = 'minipick',
          lsp = {
            config = {
              name = 'zk',
              cmd = { 'zk', 'lsp' },
              filetypes = { 'markdown' },
            },
          },
          auto_attach = { enabled = true },
        }

        commands.add('ZkOrphans', function(options)
          options = vim.tbl_extend('force', { orphan = true }, options or {})
          zk.edit(options, { title = 'Zk Orphans' })
        end)

        commands.add('ZkDaily', zk_command('ZkNew', function()
          return {
            dir = 'journal',
            title = os.date '%Y-%m-%d',
          }
        end))

        commands.add('ZkWorkNotes', function(opts)
          opts = vim.tbl_extend('force', {
            createdAfter = '3 days ago',
            tags = { 'work' },
          }, opts or {})
          zk.list(opts)
        end)
      end,
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
