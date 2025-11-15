return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
      require('mini.tabline').setup()
      require('mini.statusline').setup()
      require('mini.files').setup()
      require('mini.pairs').setup()
      require('mini.bufremove').setup()
      require('mini.indentscope').setup()
      require('mini.notify').setup()
      require('mini.trailspace').setup()
      require('mini.icons').setup()
      require('mini.diff').setup()
      require('mini.git').setup()
      require('mini.comment').setup()
      require('mini.pick').setup()
      require('mini.extra').setup()

      local miniclue = require 'mini.clue'
      miniclue.setup {
        window = {
          delay = 200,
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

      -- Re-ensure triggers after buffer-local mappings (like LSP) are added
      local clue_group = vim.api.nvim_create_augroup('mini-clue-triggers', { clear = true })
      vim.api.nvim_create_autocmd('LspAttach', {
        group = clue_group,
        callback = function(args)
          vim.schedule(function() miniclue.ensure_buf_triggers(args.buf) end)
        end,
      })

      -- Provide a picker to browse other pickers similar to Telescope's builtin list
      local minipick = require 'mini.pick'
      minipick.registry.registry = function(local_opts)
        local names = vim.tbl_keys(minipick.registry)
        table.sort(names)
        local items = vim.tbl_filter(function(name) return name ~= 'registry' end, names)
        local source = {
          items = items,
          name = 'MiniPick registry',
          choose = function(item)
            if item == nil then return end
            local picker = minipick.registry[item]
            if picker == nil then return end
            return picker(local_opts)
          end,
        }
        return minipick.start { source = source }
      end
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
      local map_multistep = require('mini.keymap').map_multistep

      map_multistep('i', '<Tab>', { 'pmenu_next' })
      map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
      map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
      map_multistep('i', '<BS>', { 'minipairs_bs' })
      -- ... and there is more!
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
    keys = {
      { '<leader>e', '<cmd>lua MiniFiles.open()<cr>', desc = 'File Explorer' },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
