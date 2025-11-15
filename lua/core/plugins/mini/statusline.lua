local M = {}

function M.setup()
  local statusline = require 'mini.statusline'

  local function lsp_status()
    local clients = vim.lsp.get_clients { bufnr = 0 }
    if #clients == 0 then return '' end
    return ' ' .. clients[1].name
  end

  statusline.setup {
    use_icons = vim.g.have_nerd_font,
    content = {
      active = function()
        local mode = statusline.section_mode { trunc_width = 120 }
        local git = statusline.section_git { icon = ' ' }
        local diag = statusline.section_diagnostics { signs = { error = ' ', warn = ' ', info = ' ' } }
        local filename = statusline.section_filename { trunc_width = 140 }
        local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
        local location = statusline.section_location()

        return statusline.combine_groups {
          { hl = 'MiniStatuslineModeNormal', strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git, diag } },
          '%<',
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=',
          { hl = 'MiniStatuslineFileinfo', strings = { lsp_status(), fileinfo } },
          { hl = 'MiniStatuslineModeNormal', strings = { location } },
        }
      end,
    },
  }

  statusline.section_location = function() return '%2l:%-2v' end

  require('mini.tabline').setup()
  require('mini.statusline').setup()
end

return M
-- vim: ts=2 sts=2 sw=2 et
