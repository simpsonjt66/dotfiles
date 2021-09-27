#!/bin/sh

set -e

if tmux has -t dotfiles 2>/dev/null; then
  tmux attach -t dotfiles
  exit
fi

tmux new-session -d -s dotfiles -n nvim -x "$(tput cols)" -y "$(tput lines)"

tmux split-window -t dotfiles:nvim -h

tmux send-keys -t dotfiles:nvim.left "nvim -c Files" Enter
tmux send-keys -t dotfiles:nvim.right "git status" Enter

tmux attach -t dotfiles:nvim.left
