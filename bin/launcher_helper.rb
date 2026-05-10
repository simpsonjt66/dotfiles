#!/usr/bin/env ruby
# frozen_string_literal: true

require 'shellwords'
require 'open3'
require 'English'
require 'yaml'

OPTIONS = YAML.load_file('/home/jsimpson/.local/bin/config.yaml')

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
  menu_options = OPTIONS['main_menu'].map { |item| item['name'] }
  selected = rofi_select(items: menu_options)

  return unless selected

  launch_command = OPTIONS['main_menu'].find { |item| item['name'] == selected }&.dig('command')
  send("show_#{launch_command}_menu")

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
  menu_prompts = OPTIONS['config_menu'].map { |item| item['prompt'] }
  selected = rofi_select(items: menu_prompts)

  filepath = OPTIONS['config_menu'].find { |item| item['prompt'] == selected }&.dig('command')

  if filepath
    expanded = File.expand_path("#{ENV['XDG_CONFIG_HOME']}/" + filepath)
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
  menu_prompts = OPTIONS['system_menu'].map { |item| item['prompt'] }
  selected = rofi_select(items: menu_prompts)

  option = OPTIONS['system_menu'].find { |item| item['prompt'] == selected }
  system(option['command']) if option['confirm'].nil? || confirm_dialog(option['confirm'])
  handle_escape
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
