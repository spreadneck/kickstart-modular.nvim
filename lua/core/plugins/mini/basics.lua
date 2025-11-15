return function()
  require('mini.basics').setup {
    options = {
      basic = true,
      extra_ui = true,
      win_borders = 'single',
    },
    mappings = {
      basic = true,
      option_toggle_prefix = [[\]],
      windows = false,
      move_with_alt = false,
    },
    autocommands = {
      basic = true,
      relnum_in_visual_mode = false,
    },
  }
end
