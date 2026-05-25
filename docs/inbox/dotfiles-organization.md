# Dotfiles Organization Suggestions

Why
- Clearer separation reduces accidental edits, makes installs predictable, and isolates secrets/vendor code.

Suggested structure and rules
- README.md, INSTALL.md: repo overview and bootstrap instructions.
- bin/: executable helper scripts (installers, symlink managers).
- scripts/: one-off or larger scripts (non-interactive utilities).
- config/: mirror XDG layout, e.g.:
  - config/zsh/
  - config/nvim/
  - config/hypr/
  - config/waybar/
  - config/rofi/
  Keep per-app config.d/ fragments under each folder.
- home/: files that belong in $HOME (templates with .example suffix, e.g., .gitconfig.example).
- hosts/<hostname>/: per-machine overrides and secrets (non-committed) or optional fragments.
- vendor/ or third_party/: vendored plugins and upstream snapshots (e.g., zsh/plugins/* moved here or Git submodules).
- secrets/: secrets.example and .gitignored local secrets. Never commit real secrets.
- themes/: paired theme assets (hypr/terminal/backgrounds) grouped by theme name.
- tests/: runnable tests for vendored plugins (e.g., zsh plugin specs) and CI checks.
- docs/: supplementary documentation and design notes.
- pkglist.txt / foreignpkglist.txt: tracked package lists for bootstrap.
- CI/: workflows, lint, and a dry-run symlink checker.

Conventions
- Small, single-purpose files. Prefer config.d modularity for live-reloadable configs.
- Keep vendor snapshots isolated; update via submodule or vendor/ with changelog.
- Provide a single bootstrap entrypoint: bin/dotfiles-symlinks (already present). Add an explicit uninstall if useful.
- Add machine-specific mapping in hosts/ and let the bootstrap script apply host fragments.
- Keep secrets out of the repo; provide .example templates and document how to create local secrets.

Concrete example tree
```
/
├─ README.md
├─ INSTALL.md
├─ bin/
│  ├─ dotfiles-symlinks
│  └─ pkg-list
├─ config/
│  ├─ zsh/
│  │  ├─ zshrc
│  │  └─ config.d/
│  ├─ nvim/
│  ├─ hypr/
│  │  └─ config.d/
│  └─ waybar/
├─ home/
│  ├─ gitconfig.example
│  └─ profile.d/
├─ hosts/
│  └─ laptop-ryan/
│     └─ hypr/
├─ vendor/
│  └─ zsh-plugins/
├─ secrets/
│  └─ secrets.example
├─ themes/
│  └─ gruvbox/
├─ tests/
├─ docs/
├─ pkglist.txt
└─ foreignpkglist.txt
```

Notes
- When adding a new app, put config under config/<app>/ and prefer modular fragments (config.d) to allow selective reload.
- Document host-specific workflows (how to add a host override) in INSTALL.md.
- Consider moving vendored zsh/plugins out of the top-level zsh/ to avoid confusion about responsibility.

