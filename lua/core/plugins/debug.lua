local M = {}

function M.config()
  return {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
    },
    keys = {
      { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
      { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
      { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Conditional Breakpoint' },
      { '<leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ') end, desc = 'Debug: Set Log Point' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'Debug: Toggle REPL' },
      { '<leader>dl', function() require('dap').run_last() end, desc = 'Debug: Run Last' },
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Debug: Toggle UI' },
      { '<leader>dt', function() require('dap-go').debug_test() end, desc = 'Debug: Go Test' },
    },
    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
      dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
      dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

      require('mason-nvim-dap').setup {
        automatic_setup = true,
        ensure_installed = {
          'delve',
        },
      }
    end,
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
