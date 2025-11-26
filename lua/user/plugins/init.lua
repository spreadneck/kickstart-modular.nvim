local collect_specs = require('core.utils').collect_specs

local modules = {
  require 'user.plugins.neogit',
  require 'user.plugins.oatmeal',
  require 'user.plugins.md',
  require 'user.plugins.zk',
}

return collect_specs(modules)
-- vim: ts=2 sts=2 sw=2 et
