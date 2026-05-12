#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'fileutils'

CONFIG_FILE = File.join(__dir__, 'links.yml')
puts CONFIG_FILE

def expand(path)
  File.expand_path(path)
end

def prompt_continue(message)
  print "#{message} Continue anyway? [y/N] "
  $stdout.flush
  response = $stdin.gets&.chomp&.downcase
  response == 'y'
end

def link_file(src, dest)
  src = expand(src)
  dest = expand(dest)

  unless File.exist?(src)
    puts "  [SKIP] Source does not exist: #{src}"
    return
  end

  if File.symlink?(dest)
    current_target = File.readlink(dest)
    if current_target == src
      puts "  [OK]  Already linked linked: #{dest}"
    else
      puts "  [FIX] Replacing existing symlink: #{dest} -> #{current_target}"
      File.unlink(dest)
    end
    return
  end

  if File.exist?(dest)
    puts "  [CONFLICT] Real file or directory exists at: #{dest}"
    exit(1) unless prompt_continue("Skipping #{dest}")
    puts "  [SKIP] #{dest}"
    return
  end

  FileUtils.mkdir_p(File.dirname(dest))
  File.symlink(src, dest)
  puts "   [LINK] #{src} -> #{dest}"
end

config = YAML.load_file(CONFIG_FILE)
src_base = expand(config.fetch('src_base'))
dest_base = expand(config.fetch('dest_base'))

config.fetch('categories', {}).each do |category, files|
  puts "\n#{category}"
  puts '-' * category.length

  Array(files).each do |entry|
    src = File.join(src_base, entry.fetch('src'))
    dest = File.join(dest_base, entry.fetch('dest'))
    link_file(src, dest)
  end
end
