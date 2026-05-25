# Hyprland Font Configuration with Includes

## Overview

This guide shows how to manage dynamic font configurations across multiple tools (Hyprland, Waybar, Dunst, Alacritty, and Rofi) without causing git churn in your dotfiles.

## Strategy

Store dynamic font configurations in `~/.local/state/current/font/` and include them from your main config files. This keeps your dotfiles clean and only the generated font configs change when you switch fonts.

## Directory Structure

```
~/.local/state/current/font/
├── hyprland.conf
├── waybar.css
├── dunst.conf
├── alacritty.toml
└── rofi.rasi
```

## Configuration Syntax

### Hyprland

**Main config** (`~/.config/hypr/hyprland.conf`):
```conf
source = ~/.local/state/current/font/hyprland.conf
```

**Font config** (`~/.local/state/current/font/hyprland.conf`):
```conf
misc {
    font_family = JetBrains Mono
}
```

### Waybar

**Main config** (`~/.config/waybar/style.css`):
```css
@import url("file:///home/username/.local/state/current/font/waybar.css");
```

**Font config** (`~/.local/state/current/font/waybar.css`):
```css
* {
    font-family: "JetBrains Mono";
    font-size: 13px;
}
```

### Dunst

**Main config** (`~/.config/dunst/dunstrc`):
```ini
[global]
include = ~/.local/state/current/font/dunst.conf
```

**Font config** (`~/.local/state/current/font/dunst.conf`):
```ini
[global]
font = JetBrains Mono 11
```

**Note**: Requires Dunst v1.9.0 or later for `include` support.

### Alacritty

**Main config** (`~/.config/alacritty/alacritty.toml`):
```toml
import = [
    "~/.local/state/current/font/alacritty.toml"
]
```

**Font config** (`~/.local/state/current/font/alacritty.toml`):
```toml
[font]
size = 11.0

[font.normal]
family = "JetBrains Mono"
style = "Regular"
```

### Rofi

**Main config** (`~/.config/rofi/config.rasi`):
```css
@import "~/.local/state/current/font/rofi.rasi"
```

**Font config** (`~/.local/state/current/font/rofi.rasi`):
```css
* {
    font: "JetBrains Mono 11";
}
```

## Git Configuration

Add the dynamic font directory to your `.gitignore`:

```gitignore
# Dynamic font configurations
.local/state/current/
```

## Font Switching Script

Your font-switching script should:

1. Create the `~/.local/state/current/font/` directory if it doesn't exist
2. Generate/update the font config files in that directory
3. Reload the relevant services (Hyprland, Waybar, Dunst, etc.)

Example structure:
```bash
#!/bin/bash

FONT_DIR="$HOME/.local/state/current/font"
mkdir -p "$FONT_DIR"

# Generate font configs
cat > "$FONT_DIR/hyprland.conf" << EOF
# Font config here
EOF

# ... generate other configs ...

# Reload services
hyprctl reload
killall waybar && waybar &
killall dunst && dunst &
```

## Benefits

- ✅ Main config files remain unchanged in git
- ✅ Clean git history without font-related noise
- ✅ Easy to switch between font configurations
- ✅ Centralized font management
- ✅ Works across multiple tools consistently