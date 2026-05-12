source $XDG_DATA_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

fpath+=$XDG_DATA_HOME//zsh/plugins/pure
autoload -U promptinit; promptinit
prompt pure

for zsh_source in $ZDOTDIR/config.d/*.zsh; do
  [ -r "$zsh_source" ] && source $zsh_source
done

export FZF_DEFAULT_COMMAND='fd --type f'

bindkey -e # emacs bindings, set to -v for vi bindings

eval "$(zoxide init zsh)"
eval "$(mise activate zsh)"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

typeset -U path PATH

path+=($HOME/.local/bin)
path+=($HOME/.local/share/npm/bin/)
path+=($CARGO_HOME/bin)

