local M = {}

function M.vim_opts(options)
  if not options then
    return
  end
  for scope, settings in pairs(options) do
    for key, value in pairs(settings) do
      vim[scope][key] = value
    end
  end
end

function M.collect_specs(mods, initial)
  local specs = vim.list_extend({}, initial or {})
  for _, mod in ipairs(mods or {}) do
    if mod and mod.config then
      local entries = mod.config()
      if entries then
        for _, spec in ipairs(entries) do
          specs[#specs + 1] = spec
        end
      end
    end
  end
  return specs
end

return M
-- vim: ts=2 sts=2 sw=2 et
