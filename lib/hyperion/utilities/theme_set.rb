# frozen_string_literal: true

module Utilities
  # Set's the current system theme
  class ThemeSet
    def self.call(new_current_theme)
      new_theme_path = File.join(THEME_PATH, new_current_theme)
      new_theme_files = File.join(new_theme_path, '/.')
      apply_theme(new_current_theme, new_theme_files)
    end
    class << self
      private

      def recreate_current_theme_directory
        FileUtils.rm_rf(CURRENT_THEME_PATH)
        FileUtils.mkdir_p(CURRENT_THEME_PATH)
      end

      def apply_theme(new_current_theme, new_theme_files)
        recreate_current_theme_directory
        write_theme_marker(new_current_theme)
        copy_theme_files(new_theme_files)
      end

      def write_theme_marker(new_current_theme)
        File.write(File.join(CURRENT_THEME_PATH, 'theme.current'), new_current_theme)
      end

      def copy_theme_files(new_theme_files)
        FileUtils.cp_r(new_theme_files, CURRENT_THEME_PATH)
      end
    end
  end
end
