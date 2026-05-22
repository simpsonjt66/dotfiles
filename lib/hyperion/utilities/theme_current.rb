# frozen_string_literal: true

module Utilities
  # Returns the current theme
  class ThemeCurrent
    def self.show
      return unless File.exist?(File.join(CURRENT_THEME_PATH, 'theme.current'))

      File.read(File.join(CURRENT_THEME_PATH, 'theme.current')).chomp
    end
  end
end
