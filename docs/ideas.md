## Toggle Menu
Nightlight 
Idle
Bar

Store a value in ~/.local/state/hyperion/. Read this value to determine whether to turn the setting on or off.


## Themes Menu
Read all theme directories and present them in a menu. In Omarchy, they have a `CURRENT_THEME_PATH` and a `NEXT_THEME_PATH`. When they set out to change the theme, they remove the `NEXT_THEME_PATH` and create a new one. Then copy the selected theme into the `NEXT_THEME_PATH`. There is some fancy turning example-theme-name into Example Theme Name, then back again. Then they remove the current theme path and then move the next theme path to current theme path. Then much restarting apps to use the current theme.

Much cleverness then ensues. They set the Gnome theme, and after having created a managed policy for chrome, change the color value there too. All very clever indeed.

My implementation runs with `hyperion/themes/current`, on reviewing omarchy, the better seeming approach would be `hyperion/current/theme/`. This would prevent having to exclude `current` from the menu list, and would save having to `.gitignore` the current folder.

I also need to look at the relaunchers etc.

Include `color_file_from_alacritty` in utilities. Logic will be something like if `colors.toml` does not exist create it. If other color files don't exist create them too.
> 

## Maintenance Menu
- [ ] Check for updates
- [ ] Check for errors
- [ ] Perform updates
- [ ] Check the logs
