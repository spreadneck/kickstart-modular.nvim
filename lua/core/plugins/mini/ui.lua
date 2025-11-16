local M = {}

-- Base16 palette matching HoNamDuong/hybrid.nvim as closely as possible.
local palette = {
  base00 = '#1d1f21',
  base01 = '#282a2e',
  base02 = '#373b41',
  base03 = '#969896',
  base04 = '#b4b7b4',
  base05 = '#c5c8c6',
  base06 = '#e0e0e0',
  base07 = '#ffffff',
  base08 = '#cc6666',
  base09 = '#de935f',
  base0A = '#f0c674',
  base0B = '#b5bd68',
  base0C = '#8abeb7',
  base0D = '#81a2be',
  base0E = '#b294bb',
  base0F = '#a3685a',
}

local mode_hl_map = {
  normal = 'MiniStatuslineModeNormal',
  insert = 'MiniStatuslineModeInsert',
  visual = 'MiniStatuslineModeVisual',
  replace = 'MiniStatuslineModeReplace',
  command = 'MiniStatuslineModeCommand',
  terminal = 'MiniStatuslineModeTerminal',
  other = 'MiniStatuslineModeOther',
}

local function apply_statusline_highlights()
  local base_bg = palette.base00
  local fg = palette.base05
  local set = vim.api.nvim_set_hl
  set(0, mode_hl_map.normal, { bg = palette.base0D, fg = base_bg, bold = true })
  set(0, mode_hl_map.insert, { bg = palette.base07, fg = base_bg, bold = true })
  set(0, mode_hl_map.visual, { bg = palette.base0A, fg = base_bg, bold = true })
  set(0, mode_hl_map.replace, { bg = palette.base08, fg = base_bg, bold = true })
  set(0, mode_hl_map.command, { bg = palette.base0E, fg = base_bg, bold = true })
  set(0, mode_hl_map.terminal, { bg = palette.base0B, fg = base_bg, bold = true })
  set(0, mode_hl_map.other, { bg = palette.base09, fg = base_bg, bold = true })
  set(0, 'MiniStatuslineGit', { bg = palette.base01, fg = palette.base0C })
  set(0, 'MiniStatuslineDiagError', { bg = palette.base08, fg = base_bg })
  set(0, 'MiniStatuslineDiagWarn', { bg = palette.base09, fg = base_bg })
  set(0, 'MiniStatuslineDiagInfo', { bg = palette.base0D, fg = base_bg })
  set(0, 'MiniStatuslineDiagHint', { bg = palette.base0C, fg = base_bg })
  set(0, 'MiniStatuslineFilenameAccent', { bg = palette.base00, fg = fg })
  set(0, 'MiniStatuslineFileinfoAccent', { bg = palette.base01, fg = fg })
  set(0, 'MiniStatuslineLocationAccent', { bg = palette.base02, fg = palette.base07 })
end

function M.setup()
  vim.o.background = 'dark'
  require('mini.base16').setup { palette = palette, name = 'hybrid-mini' }
  require('mini.colors').setup { use_background = true }
end

function M.apply_statusline()
  apply_statusline_highlights()
  vim.api.nvim_create_autocmd('ColorScheme', {
    group = vim.api.nvim_create_augroup('mini-ui-statusline', { clear = true }),
    callback = apply_statusline_highlights,
  })

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
        local mode, mode_hl = statusline.section_mode {
          trunc_width = 120,
          mode_hl = mode_hl_map,
        }
        local git = statusline.section_git { icon = ' ' }
        local filename = statusline.section_filename { trunc_width = 140 }
        local fileinfo = statusline.section_fileinfo { trunc_width = 120 }
        local location = statusline.section_location()

        local components = {
          { hl = mode_hl, strings = { mode } },
        }

        if git ~= '' then
          components[#components + 1] = { hl = 'MiniStatuslineGit', strings = { git } }
        end

        local counts = { error = 0, warn = 0, info = 0, hint = 0 }
        for _, diag in ipairs(vim.diagnostic.get(0)) do
          if diag.severity == vim.diagnostic.severity.ERROR then
            counts.error = counts.error + 1
          elseif diag.severity == vim.diagnostic.severity.WARN then
            counts.warn = counts.warn + 1
          elseif diag.severity == vim.diagnostic.severity.INFO then
            counts.info = counts.info + 1
          elseif diag.severity == vim.diagnostic.severity.HINT then
            counts.hint = counts.hint + 1
          end
        end

        local diag_segments = {
          { key = 'error', icon = ' ', hl = 'MiniStatuslineDiagError' },
          { key = 'warn', icon = ' ', hl = 'MiniStatuslineDiagWarn' },
          { key = 'info', icon = ' ', hl = 'MiniStatuslineDiagInfo' },
          { key = 'hint', icon = ' ', hl = 'MiniStatuslineDiagHint' },
        }
        for _, seg in ipairs(diag_segments) do
          local value = counts[seg.key]
          if value > 0 then
            components[#components + 1] = { hl = seg.hl, strings = { seg.icon .. value .. ' ' } }
          end
        end

        components[#components + 1] = '%<'
        components[#components + 1] = { hl = 'MiniStatuslineFilenameAccent', strings = { filename } }
        components[#components + 1] = '%='
        components[#components + 1] = { hl = 'MiniStatuslineFileinfoAccent', strings = { lsp_status(), fileinfo } }
        components[#components + 1] = { hl = 'MiniStatuslineLocationAccent', strings = { location } }

        return statusline.combine_groups(components)
      end,
    },
  }

  statusline.section_location = function() return '%2l:%-2v' end
  require('mini.tabline').setup()
end

return M
