# Dotfiles

- [tmux](https://github.com/tmux/tmux)
- [zsh](https://github.com/zsh-users/zsh)
- [neovim](https://github.com/neovim/neovim)
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [fzf](https://github.com/junegunn/fzf#as-vim-plugin)
- [i3-gaps](https://github.com/Airblader/i3)
- [st](https://st.suckless.org/)
- [git](https://git-scm.com/)

## Next Actions

- [ ] Update NeoVim configs to lua
- [ ] Sort out NeoVim plugins
- [ ] Move NeoVim to LSP
- [ ] Fix ruby version manager and locations

chruby
ruby-install


## XDG Base Directory Migration
-[fzf](https://github.com/junegunn/fzf/pull/1282)

## Ruby version management

The plan is to move the versions of ruby and rubygems out of the home directory
into the appropriate spots allocated by the xdg standard.

The version manager seems to have much less to do with that than the install
program.  I am currently running `ruby-install`  it looks like `ruby-build`
might be the way to go.
