# frozen_string_literal: true

module Menus
  # Shows the system menu with various power options
  class System
    def self.show
      menu_options = OPTIONS[:system_menu]
      prompts = menu_options.map { |item| item[:prompt] }
      selected = rofi_select(items: prompts)

      option = menu_options.find { |item| item[:prompt] == selected }
      system(option[:command]) if option[:confirm].nil? || confirm_dialog(option[:confirm])
    end
  end
end
