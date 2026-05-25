# Solo Developer Workflow for Hyprland UI Project

## 1. Use GitHub Issues

Use GitHub Issues for: - Feature requests  
- Bug reports  
- Tasks taking more than 30 minutes

Suggested labels: - feature - bug - refactor - config - ui - tui -
waybar - rofi - documentation - idea

### CLI Examples

    gh issue create --title "Waybar: Add dynamic workspace indicator" --label feature,waybar
    gh issue list
    gh issue view 12

------------------------------------------------------------------------

## 2. Use Pull Requests for Larger Work

Use PRs when: - Work spans multiple days - Many files or components are
affected - You want discussion, notes, or a clean history

Skip PRs for: - Small fixes - Quick config updates

### CLI Examples

    gh pr create --fill
    gh pr status
    gh pr merge

------------------------------------------------------------------------

## 3. Keep a Lightweight In‑Repo Scratchpad

Create a docs folder with the following:

    /docs/
        scratch.md
        ideas.md
        roadmap.md

Use them as: - scratch.md → daily notes, experiments - ideas.md →
possible features not yet issues - roadmap.md → long‑term direction

Example scratch entry:

    ## 2026‑01‑22
    - current focus: dynamic monitor layout handling
    - next tasks:
      - [ ] create issue for modular waybar modules
      - [ ] test on laptop + dual monitor

------------------------------------------------------------------------

## 4. Branch Strategy

-   main → stable
-   dev (optional) → staging
-   feature/<shortname> → active work

Example:

    git switch -c feature/waybar-rewrite

------------------------------------------------------------------------

## 5. Optional: Use Milestones for Versions

Only if you want release groupings like: - v0.1 minimal - v0.2 theming
engine

------------------------------------------------------------------------

## 6. Neovim Integration

Recommended: - Telescope GitHub extension - gh.nvim plugin - Keymaps to
open scratch.md or list issues

Example:

``` lua
vim.keymap.set("n", "<leader>is", ":edit docs/scratch.md<CR>")
vim.keymap.set("n", "<leader>gi", ":!gh issue list<CR>")
```

------------------------------------------------------------------------

## 7. Suggested Repository Structure

    project/
      hypr/
      waybar/
      rofi/
      tui/
      gui/
      scripts/
      docs/
          roadmap.md
          ideas.md
          scratch.md
      README.md

This workflow gives you: - Lightweight daily usage - Moderate structure
for bigger features - Full terminal‑friendly operation - GitHub‑native
tracking - A scalable system for open‑source work
