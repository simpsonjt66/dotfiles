# Dotfiles

###  tmux 3.0a

[Homepage](https://github.com/tmux/tmux)

#### Plugins

tmux-plugins/tpm 'tmux plugin manager'
tmux-pns/tmux-sensible
git@github.com/mattdavis90/base16-tmux

Installed from package.

###  base16-shell

###  zsh 5.8

[Homepage](https://github.com/zsh-users/zsh/)

#### Plugins

Using zplug as the plugin manager

"manfredi/zsh-async"
"sindresorhus/pure"
"zsh-users/zsh-autosuggestions"

Installed from package.

###  neovim 0.3.4

[Homepage](https://github.com/neovim/neovim)

Installed from package.

###  ripgrep 11.0.2-1

[Homepage](https://github.com/BurntSushi/ripgrep)

Installed from package.

###  fzf 0.19.0

[Homepage](https://github.com/junegunn/fzf#as-vim-plugin)

Installed and update as a neovim plugin

###  postgresql 9.5.16

Originally installed using apt-get

###  redis 3.0.6

Originally installed using apt-get

###  i3-gaps 4.16.1

[Homepage](https://github.com/Airblader/i3)

Compile from source

###  polybar 3.2.1

[Homepage](https://github.com/jaagr/polybar)

Compile from source

###  st 0.8.2

[Homepage](https://st.suckless.org/)

Compile from source

###  rofi 1.5.2-88-git-361ce7d6

Compiled from source.

### git 2.25.1

[Homepage](https://git-scm.com/)

Installed from package.

### Compton 0.1_beta2

[Homepage](https://github.com/chjj/compton)

### Google Chrome

Installed from AUR

[Homepage](https://aur.archlinux.org/packages/google-chrome/)

```bash
cd ~/Sources/google-chrome
git pull
makepkg -si
```

## Next Steps

-  Move files into subdirectories and update symlinks.
-  Move settings and functions from `rc` files to relevant files.
-  Look into using NeoVim plugins without a plugin manager.

