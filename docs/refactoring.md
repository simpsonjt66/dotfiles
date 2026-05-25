# Current Observations

1. Redundancy: Most menu classes (System, Config, Package, Browser, Editor,
   Terminal) share almost identical logic for fetching options, mapping prompts,
   calling rofi_select, and handling the result.
2. Inconsistent Navigation: Most menus return { action: :back } on
   escape/cancel, but Main returns { action: :exit }.
3. Inconsistent Configuration Keys: The config.yaml uses :name for the main menu
   but :prompt for submenus.
4. Bug Found: In menus/editor.rb, there is a bug where { action: exit } is used
   instead of { action: :exit }. Since exit is a Kernel method, this causes the
   application to terminate immediately rather than returning a status to the
   navigator.
5. Coupling: Menus are tightly coupled to the global OPTIONS constant and the
   Utilities module.

## Proposed Refactorings

1. Core Architecture:

   Menus::Base Introduce a base class to encapsulate the common "fetch -> select
   -> act" pattern. This will reduce boilerplate in each menu file by about
   60-70%.

2. Specialized Menu Handlers Create standard handlers for common actions:
   - CommandMenu: For menus that simply execute a system command (e.g., Browser,
     Editor, Terminal).
   - ConfigMenu: Specifically for opening configuration files in an editor.
   - SubMenu: For menus that navigate to other menu classes.

3. Standardize Navigator

   Move the Navigator class from launcher_helper.rb into
   lib/hyperion/navigator.rb to keep the entry point clean and make the
   navigation logic more robust.

4. Improve Utilities
   - Refactor Utilities::ThemeSet to use instance methods and clearer
     step-by-step logic.
   - Make Utilities.rofi_select more robust (e.g., handling empty item lists).

5. Graceful Config Handling Update the base class to handle both :name and
   :prompt keys gracefully, so the existing config.yaml doesn't need immediate
   changes, but remains consistent.

Immediate Fix I noticed a critical bug in menus/editor.rb:

5. Current menus/editor.rb:15 2 { action: exit } # This calls Kernel.exit
   immediately! It should be:{ action: :exit }
