alias be='bundle exec'
alias g='git'
alias path=" tr ':' '\n' <<< '$PATH'"
alias rc='bin/rails console'
alias rdb='bin/rails dbconsole'
alias rdbm='bin/rails db:migrate && db:test:prepare'
alias rs='bin/rails server'
alias t='tmux'
alias v='nvim'
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# File system
alias ls='eza -lh --group-directories-first --icons=auto'
alias l='ls'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias d='dirs -v'
