local wezterm = require 'wezterm'

-- initialize config variable
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'Fira Code Retina'
config.color_scheme = 'Catppuccin Mocha'

-- Only loads if it exists, otherwise we're default themin
config.window_background_image = '/Users/ryanwhelchel/Wallpapers/cozystarrynightthing.jpg'
config.window_background_image_hsb = {
  brightness = 0.08,
  hue = 1.0, --default 1.0
  saturation = 1.0, --default 1.0
}

-- Idk about all this
config.window_padding = {
  left = '1cell',
  right = 0,
  top = '0.5cell',
  bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true

return config
