local collect_specs = require('core.utils').collect_specs

local base_specs = {
  'preservim/vim-markdown',
  'jghauser/follow-md-links.nvim',
}

local modules = {
  require 'user.plugins.color',
  require 'user.plugins.neogit',
  require 'user.plugins.oatmeal',
  require 'user.plugins.render-markdown',
  require 'user.plugins.zk',
}

return collect_specs(modules, base_specs)
-- vim: ts=2 sts=2 sw=2 et
