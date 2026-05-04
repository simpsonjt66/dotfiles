# Copilot instructions — simpsonjt66/dotfiles

Purpose
- Provide concise, repo-specific guidance for Copilot sessions editing or extending these dotfiles.

Quick commands (what exists and how to run a single item)
- Install or update user symlinks: ./bin/dotfiles-symlinks
- List tracked packages: ./bin/pkg-list (reads pkglist.txt / foreignpkglist.txt)
- Build st (suckless terminal):
  - cd st && make            # compile locally
  - sudo make install        # optional: install system-wide (requires root)
  - Warning: installing system packages affects the system; run with care.
- Run zsh-autosuggestions tests (single spec):
  - cd zsh/plugins/zsh-autosuggestions
  - bundle install           # first-time: installs ruby deps
  - bundle exec rspec spec/strategies/history_spec.rb
- Run RuboCop lint for the plugin: cd zsh/plugins/zsh-autosuggestions && bundle exec rubocop
- Format Neovim Lua with stylua (single file): stylua -c nvim/stylua.toml <path/to/file.lua>

High-level architecture (big picture)
- This is a monorepo-style dotfiles collection organized by application/area:
  - hypr/ and hypr/config.d: Hyprland (Wayland) configuration split into modular files
  - themes/: per-theme Hyprland + terminal + background assets
  - waybar/, rofi/: status bar and launcher configurations
  - nvim/: Neovim lua config, plugin lockfiles (lazyvim.json, lazy-lock.json), stylua formatting
  - zsh/: zsh config and vendored plugins (zsh/plugins/*). zsh/config holds modular zshrc pieces
  - bin/: cross-machine scripts (executable helpers and installers). Prefer editing/adding here for reusable scripts
  - st/: source for suckless st terminal (requires local build)
  - git/: git_template and global config snippets used for repo-local git templates
  - pkglist.txt / foreignpkglist.txt: tracked package lists for bootstrap/replication
- Many components are intentionally modular: Hyprland uses config.d, zsh uses separated files under zsh/config; themes pair terminal + WM configs to keep visual cohesion.

Key conventions (repo-specific patterns and gotchas)
- Hyprland config splitting: hypr/hyprland.conf includes hypr/config.d/* — edit config.d files for focused changes and use hyprctl reload to apply changes live.
- Themes are paired: themes/<name>/hyprland.conf and themes/<name>/<terminal>.toml/.conf provide consistent appearance; when adding a theme, include both WM and terminal files.
- Vendored plugins: zsh/plugins contains third-party plugins (some with test suites). Treat them as upstream snapshots — run their own tests and update separately.
- Secrets: zsh/secrets.zsh and zsh/secrets.zsh.example — keep secrets out of the repo; edit local secrets files only.
- st (suckless): configuration is source-based (config.h). Rebuild locally after edits — changes are not applied by copying files alone.
- Scripts in bin/ are intended to be executable; keep them POSIX/bash-compatible if possible and add inline comments for flags.
- git template hooks: git/git_template/ is used for local git init templates; if adding hooks, ensure they are executable.
- Package lists: update pkglist.txt and foreignpkglist.txt when adding or removing packages. There is no universal installer; use the package manager you prefer.

Existing assistant/context files to consult
- COPILOT.md and .copilot-context.md contain system-level context used previously: Arch Linux, Hyprland, Waybar, Rofi, zsh, kitty, workspace/monitor notes. Use them to infer default environments and key live-testing approaches (e.g., hyprctl).

If editing or adding configs that affect the running system
- State the platform impact (e.g., will install packages, change window manager behavior, or require root), give the exact command, and warn about risks.
- Prefer local testing first (e.g., compile st locally, run hyprctl reload to test Hyprland changes) before recommending system-wide install.

Where to run targeted tests and linters
- zsh plugin tests: run inside zsh/plugins/zsh-autosuggestions using bundle exec rspec. Single-test invocations are recommended (spec path).
- RuboCop (Ruby lint) is available for the plugin via bundle exec rubocop.
- Stylua for Lua formatting: use the repo nvim/stylua.toml; format a single file with stylua -c nvim/stylua.toml <file>.

Notes for Copilot sessions
- Respect vendored plugin boundaries: when modifying a plugin under zsh/plugins/*, run that plugin's tests and update its changelog if necessary.
- Prefer small, surgical changes (one config/file per PR) because changes can affect the running desktop environment.
- For live Hyprland testing use hyprctl reload (or other hyprctl dispatch commands) and prefer editing hypr/config.d fragments rather than a monolithic file.

Summary
- Created concise, repo-specific Copilot guidance with commands to run single tests/linters, a high-level architecture summary, and key repo conventions.
- For changes that affect the system, include explicit warnings and local-test instructions.

If anything important is missing or you want coverage for additional areas (packaging/bootstrap scripts, dotfile install flows, or CI hooks), say which area to expand and Copilot will add it.
