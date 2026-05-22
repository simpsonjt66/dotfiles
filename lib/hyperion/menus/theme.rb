# frozen_string_literal: true

module Menus
  # Menu to list and select current themes
  class Theme
    def self.show
      lookup = Utilities::ThemeList.show
      current_theme = Utilities::ThemeCurrent.show
      default_selection = current_theme && lookup.key(current_theme) || nil
      selected = Utilities.rofi_select(items: lookup.keys, current: default_selection)

      return { action: :back } if selected.nil?

      Utilities::ThemeSet.call(lookup[selected])
      system('notify-send', "Theme set to #{selected}")
    end
  end
end
