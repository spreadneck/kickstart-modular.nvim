return {
  'zk-org/zk-nvim',

  keys = {
    -- New note
    {
      '<leader>zn',
      function()
        require('zk.commands').get 'ZkNew'()
      end,
      desc = 'Zk: New note',
    },

    -- Daily note
    {
      '<leader>zd',
      function()
        require('zk').new { dir = 'journal' }
      end,
      desc = 'Zk: Daily note',
    },

    -- New from title selection (visual mode)
    {
      '<leader>zN',
      function()
        require('zk.commands').get 'ZkNewFromTitleSelection'()
      end,
      mode = 'v',
      desc = 'Zk: New note from title selection',
    },

    -- Orphans
    {
      '<leader>zo',
      function()
        require('zk.commands').get 'ZkOrphans' {}
      end,
      desc = 'Zk: Orphans',
    },

    -- Search notes (all)
    {
      '<leader>zs',
      function()
        require('zk.commands').get 'ZkNotes' {}
      end,
      desc = 'Zk: Search notes',
    },

    -- Work notes (your custom)
    {
      '<leader>zw',
      function()
        require('zk.commands').get 'ZkNotes' {
          createdAfter = '3 days ago',
          tags = { 'work' },
        }
      end,
      desc = 'Zk: Work notes (last 3 days)',
    },

    -- Backlinks
    {
      '<leader>zb',
      function()
        require('zk.commands').get 'ZkBacklinks'()
      end,
      desc = 'Zk: Backlinks',
    },

    -- Insert link
    {
      '<leader>zl',
      function()
        require('zk.commands').get 'ZkInsertLink'()
      end,
      desc = 'Zk: Insert link',
    },

    -- Insert link to a new note
    {
      '<leader>zL',
      function()
        require('zk.commands').get 'ZkNew' { link = true }
      end,
      desc = 'Zk: Insert new linked note',
    },
  },

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

    ---------------------------------------------------------------------
    -- Custom command definitions
    ---------------------------------------------------------------------

    commands.add('ZkOrphans', function(options)
      options = vim.tbl_extend('force', { orphan = true }, options or {})
      zk.edit(options, { title = 'Zk Orphans' })
    end)

    commands.add('ZkDaily', function()
      require('zk.commands').get 'ZkNew' {
        dir = 'journal',
        title = os.date '%Y-%m-%d',
      }
    end)

    commands.add('ZkWorkNotes', function(opts)
      opts = vim.tbl_extend('force', {
        createdAfter = '3 days ago',
        tags = { 'work' },
      }, opts or {})
      zk.list(opts)
    end)
  end,
}
