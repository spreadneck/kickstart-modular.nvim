local M = {}

function M.setup()
  local hipatterns = require 'mini.hipatterns'
  hipatterns.setup {
    highlighters = {
      fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
      hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
      todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
      note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  }
end

return M
-- vim: ts=2 sts=2 sw=2 et
