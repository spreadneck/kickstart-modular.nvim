local M = {}
M.vim_opts = function(options)
  if options then
    for scope, settings in pairs(options) do
      for key, value in pairs(settings) do
        vim[scope][key] = value
      end
    end
  end
end

return M
