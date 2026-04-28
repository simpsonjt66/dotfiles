#!/usr/bin/env ruby

# Sets the system-wide monospaced font for various applications.
#
# This script takes a font name as an argument and updates the configuration
# files for Alacritty, Dunst, Waybar, and Fontconfig.

new_font = ARGV[0]

# Escape any special characters in the new font name to avoid regex issues
new_font = Regexp.escape(new_font) if new_font

# Check if a font name was provided and it's not "CNCLD"
if new_font && new_font != "CNCLD"
  # Check if the font is installed on the system.
  fc_list_output = `fc-list`.downcase
  
  if fc_list_output.include?(new_font.downcase)
    # --- Update Alacritty configuration ---
    # Replaces the value of the 'family' key in alacritty.toml.
    alacritty_config = File.expand_path("~/.local/state/current/font/alacritty.toml")
    if File.exist?(alacritty_config)
      content = File.read(alacritty_config)
      content.gsub!(/family = "[^"]*"/, "family = \"#{new_font}\"")
      File.write(alacritty_config, content)
    end

    # --- Update Dunst configuration ---
    # Replaces the font name in dunstrc, keeping the font size.
    # dunst_config = File.expand_path("~/.config/dunst/dunstrc")
    # if File.exist?(dunst_config)
    #   content = File.read(dunst_config)
    #   content.gsub!(/^\s*(font\s*=\s*)(.*)(\s+\d+)/, "\\1#{new_font}\\3")
    #   File.write(dunst_config, content)
    # end

    # --- Update Waybar configuration ---
    # Replaces the font-family in style.css.
    # waybar_style = File.expand_path("~/.config/waybar/style.css")
    # if File.exist?(waybar_style)
    #   content = File.read(waybar_style)
    #   content.gsub!(/font-family: .*;/, "font-family: '#{new_font}';")
    #   File.write(waybar_style, content)
    # end

    # --- Update Fontconfig configuration ---
    # Sets the preferred monospace font for applications that use fontconfig.
    # require 'rexml/document'
    # fontconfig = File.expand_path("~/.config/fontconfig/fonts.conf")
    # if File.exist?(fontconfig)
    #   doc = REXML::Document.new(File.read(fontconfig))
    #   doc.elements.each("//alias[family='monospace']/prefer/family") do |elem|
    #     elem.text = new_font
    #   end
    #   File.write(fontconfig, doc.to_s)
    # end

    # Rebuild the font cache to apply the changes.
    # system("fc-cache -f")
    
    # Send a notification to confirm the font change.
    system("notify-send 'System font updated to #{new_font}'")
  else
    puts "Font '#{new_font}' not found."
    exit 1
  end
else
  # Print usage message if no font name is provided.
  puts "Usage: font-set <font-name>"
end
