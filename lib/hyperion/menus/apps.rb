# frozen_string_literal: true

module Menus
  # Shows rofi in drun mode as an app launcher
  class Apps
    def self.show
      IO.popen(['rofi',
                '-show', 'drun',
                '-run-command', 'uwsm-app {cmd}',
                '-theme', '~/.config/rofi/themes/app-launcher.rasi'])
    end
  end
end
