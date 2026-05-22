# frozen_string_literal: true

module Utilities
  # Returns a list of theme folders and human readable options
  class ThemeList
    def self.show
      theme_directories = File.join(THEME_PATH, '/*/')
      themes = Dir.glob(theme_directories).map { |d| File.basename(d) }.reject { |d| d == 'current' }
      themes.each_with_object({}) do |d, h|
        h[d.split('-').map(&:capitalize).join(' ')] = d
      end
    end
  end
end
