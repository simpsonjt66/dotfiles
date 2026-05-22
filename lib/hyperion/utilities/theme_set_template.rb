#!/usr/bin/env ruby
# frozen_string_literal: true

require 'tempfile'

templates_dir      = File.join('./templates/')
next_theme_dir     = File.join('./config_files/')
colors_file        = File.join(next_theme_dir, 'colors.toml')

def hex_to_rgb(hex)
  hex = hex.delete_prefix('#')
  r = hex[0, 2]
  g = hex[2, 2]
  b = hex[4, 2]
  "#{r.hex},#{g.hex},#{b.hex}"
end

exit 0 unless File.exist?(colors_file)

# Parse colors.toml into a { key => value } hash
colors = File.foreach(colors_file).each_with_object({}) do |line, h|
  key, _, value = line.partition('=')
  key = key.gsub(/["'\s]/, '')
  next if key.empty? || key.start_with?('#')

  value = value[/["']([^"']*)["']/, 1] || next
  h[key] = value
end

# Build substitution map: key -> replacement string
substitutions = {}
colors.each do |key, value|
  substitutions["{{ #{key} }}"]       = value
  substitutions["{{ #{key}_strip }}"] = value.delete_prefix('#')
  substitutions["{{ #{key}_rgb }}"]   = hex_to_rgb(value) if value.start_with?('#')
end

# Compile into a single regex for efficiency
pattern = Regexp.union(substitutions.keys)

# Process user templates first (they take priority over built-in)
templates = Dir.glob(File.join(templates_dir, '*.tpl'))

templates.each do |tpl|
  filename    = File.basename(tpl, '.tpl')
  output_path = File.join(next_theme_dir, filename)

  next if File.exist?(output_path)

  result = File.read(tpl).gsub(pattern, substitutions)
  File.write(output_path, result)
end
