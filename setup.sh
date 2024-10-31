#!/bin/sh

ln -sf ~/Code/dotfiles/zsh/config ~/.config/zsh
ln -s ~/Code/dotfiles/bin/* ~/.local/bin

git submodule update --init --recursive

source  ~/.config/zsh/.zshrc
