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

function M.with_prompt(cmd)
  return function()
    if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then
      return
    end
    return cmd()
  end
end

function M.prompt_input(opts)
  opts = opts or {}
  local prompt = opts.prompt or 'Input'
  local default = opts.default or ''
  local on_submit = opts.on_submit or function() end

  local input = vim.fn.input(prompt .. ': ', default)
  if input == nil then
    if opts.on_cancel then
      opts.on_cancel()
    end
    return
  end
  input = vim.trim(input)
  if input == '' then
    on_submit(nil)
  else
    on_submit(input)
  end
end

return M
-- vim: ts=2 sts=2 sw=2 et
