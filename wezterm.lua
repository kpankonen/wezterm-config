local wezterm = require 'wezterm'

local mux = wezterm.mux
local act = wezterm.action

local is_darwin <const> = wezterm.target_triple:find("darwin") ~= nil
local is_linux <const> = wezterm.target_triple:find("linux") ~= nil

local alt_key
local font_size
local shell

if is_darwin then
  alt_key = "CMD"
  font_size = 16
  shell = "/opt/homebrew/bin/bash"
else
  alt_key = "ALT"
  font_size = 13
  shell = "bash"
end

local config = {
  quit_when_all_windows_are_closed = false,
  use_dead_keys = false,
  audible_bell = "Disabled",
  default_prog = { shell, '-l' },
  check_for_updates = false,

  initial_rows = 30,
  initial_cols = 100,
  scrollback_lines = 1000000,

  adjust_window_size_when_changing_font_size = false,
  hide_tab_bar_if_only_one_tab = true,
  pane_focus_follows_mouse = true,

  selection_word_boundary = " \t\n{}[]()\"'`$|:*",

  color_scheme = 'Tango (terminal.sexy)',

  colors = {
    foreground = 'white',
    cursor_bg = 'white',
    cursor_fg = 'black',
    selection_fg = 'black',
    selection_bg = 'white',
    split = '#c9c5c5',
  },

  font = wezterm.font('Cousine Nerd Font', { weight = 'Medium' }),
  font_size = font_size,
  warn_about_missing_glyphs = false,

  keys = {
    { key = 'd', mods = alt_key, action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
    { key = 'D', mods = alt_key, action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = "[", mods = alt_key, action = act.ActivatePaneDirection("Prev")},
    { key = "]", mods = alt_key, action = act.ActivatePaneDirection("Next")},
  }
}

if is_darwin then
  table.insert(config.keys, { key = "Enter", mods = alt_key, action = act.ToggleFullScreen })
  table.insert(config.keys, { key = "w", mods = alt_key, action = act.DisableDefaultAssignment })
  table.insert(config.keys, { key = "f", mods = alt_key, action = act.DisableDefaultAssignment })
  table.insert(config.keys, { key = "f", mods = "OPT", action = act.Search("CurrentSelectionOrEmptyString") })
else
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = alt_key,
      action = act.ActivateTab(i - 1),
    })
  end

  table.insert(config.keys, { key = 'v', mods = alt_key, action = act.PasteFrom 'Clipboard' })
  table.insert(config.keys, { key = 'v', mods = 'SUPER', action = act.PasteFrom 'Clipboard' })
  table.insert(config.keys, { key = 'c', mods = alt_key, action = act.CopyTo 'ClipboardAndPrimarySelection' })
  table.insert(config.keys, { key = 'c', mods = 'SUPER', action = act.CopyTo 'ClipboardAndPrimarySelection' })
  table.insert(config.keys, { key = 't', mods = alt_key, action = act.SpawnTab 'CurrentPaneDomain' })
end

return config
