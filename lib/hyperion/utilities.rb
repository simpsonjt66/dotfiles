# This folder is symlinked to ~/.local/lib/
# This will contain the link all the other supporting files
# and other utility functions.

require_relative 'menus/main'
require_relative 'menus/apps'
require_relative 'menus/config'
require_relative 'menus/system'
require_relative 'menus/font'

# Urtility functions for app launcher
module Utilities
  def self.rofi_select(items:, current: nil)
    current_index = current ? items.index(current) || 0 : 0

    result = IO.popen(rofi_command(items, current_index), 'r+') do |io|
      io.puts items
      io.close_write
      result = io.read.chomp
    end

    $CHILD_STATUS.success? && !result.empty? ? result : nil
  end

  def self.confirm_dialog(message)
    system('confirm-dialog', message)
  end

  def self.rofi_command(items, current_index)
    longest = items.max_by(&:length).length

    [
      'rofi',
      '-dmenu',
      '-p', 'Launch',
      '-selected-row', current_index.to_s,
      '-i', '-l', items.count.to_s,
      '-theme', '~/.config/rofi/themes/system-menu.rasi',
      '-theme-str', "window { width: #{longest} em;}"
    ]
  end
end
