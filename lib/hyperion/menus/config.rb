# frozen_string_literal: true

module Menus
  # Launches the config menu to edit most used config files
  class Config
    def self.show
      menu_options = OPTIONS[:config_menu]
      prompts = menu_options.map { |item| item[:prompt] }
      selected = Utilities.rofi_select(items: prompts)

      filepath = menu_options.find { |item| item[:prompt] == selected }&.dig(:command)

      return unless selected

      expanded = File.expand_path("#{ENV['XDG_CONFIG_HOME']}/" + filepath)
      system('notify-send', "Editing config file #{expanded}")
      system('launch-editor', expanded)
    end
  end
end
