#!/usr/bin/env ruby
# frozen_string_literal: true

require 'shellwords'
require 'open3'
require 'English'
require 'yaml'
require_relative('../lib/hyperion/utilities')

OPTIONS = YAML.load_file('/home/jsimpson/.local/bin/config.yaml', symbolize_names: true)

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
  Menus::Font.show
else
  exit 1
end
