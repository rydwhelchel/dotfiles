local wezterm = require 'wezterm'
local wallpaper = require 'wallpaper'

-- initialize config variable
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

wallpaper.set(config)
config.font = wezterm.font 'Fira Code Retina'
config.color_scheme = 'Catppuccin Mocha'

-- Idk about all this
config.window_padding = {
  left = '1cell',
  right = 0,
  top = '0.5cell',
  bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true

return config
