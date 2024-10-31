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

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
     [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
         eval "$("$BASE16_SHELL/profile_helper.sh")"

eval "$(zoxide init zsh)"


source /usr/share/chruby/chruby.sh
source /usr/share/chruby/auto.sh


[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

