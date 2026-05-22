# frozen_string_literal: true

require 'fileutils'

theme_source = ARGV[0]

if theme_source.nil? || theme_source.empty?
  warn 'Usage: color_file_from_alacritty <theme-dir>'
  exit 1
end

colors_output = File.join(theme_source, 'colors.toml')
alacritty_file = File.join(theme_source, 'alacritty.toml')

exit 0 if File.exist?(colors_output)
exit 0 unless File.exist?(alacritty_file)

def strip_comment(value)
  out = +''
  in_single = false
  in_double = false
  prev = ''

  value.each_char do |ch|
    if ch == '"' && !in_single && prev != '\\'
      in_double = !in_double
    elsif ch == "'" && !in_double
      in_single = !in_single
    end

    break if ch == '#' && !in_single && !in_double

    out << ch
    prev = ch
  end

  out.rstrip
end

def parse_color(file_path, section, key)
  in_section = false

  File.foreach(file_path) do |line|
    if line.match?(/^\s*\[/)
      in_section = line.match?(/^\s*\[#{Regexp.escape(section)}\]\s*$/)
      next
    end

    next unless in_section

    stripped = strip_comment(line)
    split_pos = stripped.index('=')
    next unless split_pos

    current_key = stripped[0, split_pos].strip
    current_value = stripped[split_pos + 1..].strip

    next unless current_key == key

    current_value.gsub!(/["'#]/, '')
    current_value.sub!(/^0[xX]/i, '')

    return current_value if current_value.match?(/^[0-9A-Fa-f]{6}$/)
  end

  nil
end

def normalize_hex(color)
  return nil if color.nil? || color.empty?

  color = color.delete_prefix('0x').delete_prefix('0X').delete_prefix('#')
  return nil unless color.match?(/^[0-9a-fA-F]{6}$/)

  "##{color.downcase}"
end

def extract_color(file, section, key)
  raw = parse_color(file, section, key)
  return nil unless raw&.match?(/^[0-9a-fA-F]{6}$/)

  normalize_hex(raw)
end

def try_both(file, section_suffix, key)
  extract_color(file, "colors.#{section_suffix}", key) ||
    extract_color(file, 'colors', "#{section_suffix}.#{key}")
end

names = %w[black red green yellow blue magenta cyan white]

# Extract normal colors (0-7)
normal = names.map { |name| try_both(alacritty_file, 'normal', name) }

if normal.any?(&:nil?)
  warn "Warning: Cannot extract all normal colors from #{alacritty_file}, skipping generation"
  exit 0
end

# Extract bright colors (8-15), falling back to normal
bright = names.each_with_index.map do |name, i|
  try_both(alacritty_file, 'bright', name) || normal[i]
end

colors = normal + bright

# Extract primary, cursor, and selection colors
background         = try_both(alacritty_file, 'primary',   'background')
foreground         = try_both(alacritty_file, 'primary',   'foreground')
cursor             = try_both(alacritty_file, 'cursor',    'cursor')
selection_bg       = try_both(alacritty_file, 'selection', 'background')
selection_fg       = try_both(alacritty_file, 'selection', 'text')

# Apply defaults
background    ||= colors[0]
foreground    ||= colors[7]
cursor        ||= foreground
selection_bg  ||= foreground
selection_fg  ||= background
accent          = colors[4]

FileUtils.mkdir_p(theme_source)

File.write(colors_output, <<~TOML)
  accent = "#{accent}"
  cursor = "#{cursor}"
  foreground = "#{foreground}"
  background = "#{background}"
  selection_foreground = "#{selection_fg}"
  selection_background = "#{selection_bg}"

  #{colors.each_with_index.map { |c, i| "color#{i} = \"#{c}\"" }.join("\n  ")}
TOML
