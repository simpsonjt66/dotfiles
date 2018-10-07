#  vi: ft=zsh

# Locales
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Theme to load for zshell
ZSH_THEME="sobole"

# Disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Plugins
plugins=(
  bundler
  git
  tmuxinator
  zsh-autosuggestions
  zsh-syntax-highlighting
  )

# Source the oh-my-zsh files
source $ZSH/oh-my-zsh.sh

# Source Tmuxinator completions
source ~/.tmux/tmuxinator.zsh

export EDITOR='nvim'

# always start with 256 colors JS
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

# Aliases
alias mux='tmuxinator'
alias rc='spring rails console --sandbox'
alias rct='spring rails console test --sandbox'
alias typeless='history | tail -n 20000 | sed "s/.* //" | sort | uniq -c | sort -g | tail -n 100'


# Source fzf setup script
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Default command for fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

# Setup BASE16 color schemes
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# heroku autocomplete setup
HEROKU_AC_ZSH_SETUP_PATH=/home/jsimpson/.cache/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;

# Seed Voyage specific environment variables for Stripe
export PUBLISHABLE_KEY="pk_test_4BcC6hjmpzeXJaBwEfmRGFte"
export SECRET_KEY="sk_test_athgo7JVqyAbPmkZVTHrdJSo"

# Add rbenv to path
export PATH="$HOME/.rbenv/bin:$PATH"

# Initialize RBenv
eval "$(rbenv init -)"
