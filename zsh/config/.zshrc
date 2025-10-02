source $HOME/.local/bin/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

fpath+=$HOME/.local/bin/zsh/pure
autoload -U promptinit; promptinit
prompt pure

for zsh_source in $XDG_CONFIG_HOME/zsh/*.zsh; do
  source $zsh_source
done

export FZF_DEFAULT_COMMAND='fd --type f'

bindkey -e # emacs bindings, set to -v for vi bindings

eval "$(zoxide init zsh)"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

