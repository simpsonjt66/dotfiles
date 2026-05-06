#!/usr/bin/env ruby
# frozen_string_literal: true

require 'shellwords'
require 'open3'
require 'English'

MAIN_MENU_OPTIONS = {
  '󰀻 Apps' => 'apps',
  ' Config' => 'config',
  ' Font' => 'font',
  ' System' => 'system',
  '󰸌 Theme' => 'theme',
  ' Screenshot' => 'screenshot',
  '󰔎 Toggle' => 'toggle'
}.freeze

SYSTEM_MENU_OPTIONS = [
  { prompt: ' Lock',     command: 'loginctl lock-session' },
  { prompt: ' Suspend',  command: 'systemctl suspend', confirm: 'Suspend system?' },
  { prompt: '󰈆 Logout',   command: 'hyprctl dispatch exit', confirm: 'Logout?' },
  { prompt: ' Reboot',   command: 'systemctl reboot', confirm: 'Reboot system?' },
  { prompt: '󰐥 Shutdown', command: 'systemctl poweroff', confirm: 'Shutdown system?' }
].freeze

def rofi_select(items:, current: nil)
  current_index = current ? items.index(current) || 0 : 0
  result = nil
  lines = items.count.to_s
  longest = items.max_by(&:length).length
  IO.popen(['rofi',
            '-dmenu',
            '-p', 'Launch',
            '-selected-row', current_index.to_s,
            '-i', '-l', lines,
            '-theme', '~/.config/rofi/themes/system-menu.rasi',
            '-theme-str', "window { width: #{longest} em;}"],
           'r+') do |io|
    io.puts items
    io.close_write
    result = io.read.chomp
  end
  $CHILD_STATUS.exitstatus.zero? && !result.empty? ? result : nil
end

def show_main_menu
  @menu_stack.push(:main)
  selected = rofi_select(items: MAIN_MENU_OPTIONS.keys)
  return unless selected

  send("show_#{MAIN_MENU_OPTIONS[selected]}_menu")

  @menu_stack.pop
end

def show_apps_menu
  @menu_stack.push(:apps)
  IO.popen(['rofi',
            '-show', 'drun',
            '-run-command', 'uwsm-app {cmd}',
            '-theme', '~/.config/rofi/themes/app-launcher.rasi'])
  @menu_stack.pop
end

def show_config_menu
  @menu_stack.push(:config)
  menu_options = {
    ' Alacritty' => "#{ENV['XDG_CONFIG_HOME']}/alacritty/alacritty.toml",
    ' Dunst' => "#{ENV['XDG_CONFIG_HOME']}/dunst/dunstrc",
    ' Hypridle' => "#{ENV['XDG_CONFIG_HOME']}/hypr/hypridle.conf",
    ' Hyprland' => "#{ENV['XDG_CONFIG_HOME']}/hypr/hyprland.conf",
    ' Kitty' => "#{ENV['XDG_CONFIG_HOME']}/kitty/kitty.conf",
    ' Rofi' => "#{ENV['XDG_CONFIG_HOME']}/rofi/config.rasi",
    ' Waybar' => "#{ENV['XDG_CONFIG_HOME']}/waybar/config.jsonc",
    ' Zsh' => "#{ENV['XDG_CONFIG_HOME']}/zsh/.zshrc"
  }
  names = menu_options.keys
  selected = rofi_select(items: names)

  filepath = menu_options[selected]

  if filepath
    expanded = File.expand_path(filepath)
    system('notify-send', "Editing config file #{expanded}")
    system('launch-editor', expanded)
  end
  handle_escape
end

def show_font_menu
  @menu_stack.push(:font)
  menu_options = Open3.capture3('font-list')[0].lines.map(&:chomp)
  current_font = Open3.capture3('font-current')[0].strip
  selected = rofi_select(items: menu_options, current: current_font)
  system('font-set', selected) if selected
  handle_escape
end

def show_system_menu
  @menu_stack.push(:system)
  selected = rofi_select(items: SYSTEM_MENU_OPTIONS.map { |opt| opt[:prompt] })

  option = SYSTEM_MENU_OPTIONS.find { |opt| opt[:prompt] == selected }

  if option
    system(option[:command]) if option[:confirm].nil? || confirm_dialog(option[:confirm])
  else
    handle_escape
  end
end

def confirm_dialog(message)
  system('confirm-dialog', message)
end

def handle_escape
  if @menu_stack.length > 1
    @menu_stack.pop
    parent_menu = @menu_stack.last
    send("show_#{parent_menu}_menu")
  else
    exit(0)
  end
end

@menu_stack = []

menu_main = ARGV[0] || 'main'

case menu_main
when 'main'
  show_main_menu
when 'apps'
  show_apps_menu
when 'config'
  show_config_menu
when 'system'
  show_system_menu
when 'font'
  show_font_menu
else
  exit 1
end
