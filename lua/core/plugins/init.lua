local utils = require 'core.utils'

local modules = {
  require 'core.plugins.mini',
  require 'core.plugins.treesitter',
  require 'core.plugins.lspconfig',
  require 'core.plugins.blink-cmp',
  require 'core.plugins.conform',
  require 'core.plugins.lint',
}

return utils.collect_specs(modules)
-- vim: ts=2 sts=2 sw=2 et
