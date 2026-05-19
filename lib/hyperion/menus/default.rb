# frozen_string_literal: true

module Menus
  # Defaults menu
  class Default
    def self.show
      menu_options = OPTIONS[:default_menu]
      prompts = menu_options.map { |item| item[:prompt] }
      selected = Utilities.rofi_select(items: prompts)

      return unless selected

      launch_command = menu_options.find { |item| item[:prompt] == selected }&.dig(:command).to_s.capitalize
      Menus.const_get(launch_command).show
    end
  end
end
