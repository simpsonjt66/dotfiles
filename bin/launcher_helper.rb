#!/usr/bin/env ruby
# frozen_string_literal: true

require 'shellwords'
require 'open3'
require 'English'
require 'yaml'
require_relative('../lib/hyperion/utilities')

OPTIONS = YAML.load_file('/home/jsimpson/.local/bin/config.yaml', symbolize_names: true)

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

def show_font_menu
  menu_options = Open3.capture3('font-list')[0].lines.map(&:chomp)
  current_font = Open3.capture3('font-current')[0].strip
  selected = rofi_select(items: menu_options, current: current_font)
  system('font-set', selected) if selected
end

def confirm_dialog(message)
  system('confirm-dialog', message)
end

# TODO: Design a new way to handle escape
# def handle_escape
#   if @menu_stack.length > 1
#     @menu_stack.pop
#     parent_menu = @menu_stack.last
#     send("show_#{parent_menu}_menu")
#   else
#     exit(0)
#   end
# end

# @menu_stack = []

menu_main = ARGV[0] || 'main'

case menu_main
when 'main'
  Menus::Main.show
when 'apps'
  Menus::Apps.show
when 'config'
  Menus::Config.show
when 'system'
  Menus::System.show
when 'font'
  show_font_menu
else
  exit 1
end
