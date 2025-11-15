local M = {}

M.specs = {
  require 'core.plugins.mini',
  require 'core.plugins.treesitter',
  require 'core.plugins.lspconfig',
  require 'core.plugins.blink-cmp',
  require 'core.plugins.conform',
  require 'core.plugins.lint',
  -- Optional extras can be appended here, for example:
  -- require 'core.plugins.debug',
}

return M
