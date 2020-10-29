# Scratchpad for testing scripts and dotfiles

This is a store for new scripts, functions and tests before they migrate into
the dotfiles folder.

Folder structure for the new dotfiles repo:-

```
dotfiles
|
|___bin
|
|___git
|
|___tmux
|
|___vim
|
|___zsh
```

Port all the tmux and zsh files over as is, then symlink them.

## tmux-test

A script that will migrate into a zsh function, that will automatically launch
tmux if not running, and switch to an existing session if it is. This script is
inspired by [this file](https://github.com/christoomey/dotfiles/blob/master/bin/tat)

I want to compare it to [the tmux function here](https://github.com/wincent/wincent/blob/master/aspects/dotfiles/files/.zsh/functions)

Alias tmux to t in the zsh aliases for more functionality.

## git-test

A script that will become a zsh function which is a wrapper for git that will
also add the functionality to cd back to the root of a git project. Currently it
appears to be functioning just fine, but it wont actually cd.

Inspired by [this](https://github.com/wincent/wincent/blob/master/aspects/dotfiles/files/.zsh/functions)

Alias git to g and add several new options in the .gitconfig file.

