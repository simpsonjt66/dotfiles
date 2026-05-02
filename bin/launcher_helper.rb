#!/usr/bin/env ruby
# frozen_string_literal: true

require 'shellwords'
require 'open3'

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
  $?.exitstatus == 0 && !result.empty? ? result : nil
end

def show_main_menu
  menu_options = [
    '󰀻 Apps',
    ' Config',
    ' Font',
    ' System',
    '󰸌 Theme',
    ' Screenshot',
    '󰔎 Toggle'
  ]
  case rofi_select(items: menu_options)
  when /Apps/
    IO.popen(['rofi', '-show', 'drun', '-theme', '~/.config/rofi/themes/app-launcher.rasi'])
  when /Config/
    show_config_menu
  when /System/
    show_system_menu
  when /Font/
    show_font_menu
  else
    puts 'No Match'
  end
end

def show_config_menu
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
  else
    show_main_menu
  end
end

def show_font_menu
  menu_options = Open3.capture3('font-list')[0].lines.map(&:chomp)
  current_font = Open3.capture3('font-current')[0].strip
  selected = rofi_select(items: menu_options, current: current_font)
  if selected
    system('font-set', selected)
  else
    show_main_menu
  end
end

def show_system_menu
  menu_options = [
    ' Lock',
    ' Suspend',
    '󰈆 Logout',
    ' Reboot',
    '󰐥 Shutdown'
  ]
  case rofi_select(items: menu_options)
  when /Lock/
    system('loginctl lock-session')
  when /Suspend/
    system('systemctl suspend') if confirm_dialog('Suspend system?')
  when /Logout/
    system('hyprctl dispatch exit') if confirm_dialog('Logout?')
  when /Reboot/
    system('systemctl reboot') if confirm_dialog('Reboot system?')
  when /Shutdown/
    system('systemctl poweroff') if confirm_dialog('Shutdown system?')
  else
    show_main_menu
  end
end

def confirm_dialog(message)
  system('confirm-dialog', message)
end

menu_main = ARGV[0] || 'main'

case menu_main
when 'main'
  show_main_menu
when 'config'
  show_config_menu
when 'system'
  show_system_menu
when 'font'
  show_font_menu
else
  exit 1
end

exit 0
