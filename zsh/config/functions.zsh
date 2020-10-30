# shows top 10 most commonly run commands targets for aliasing
function zsh-stats() {
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n25
}

# sources .zshrc
function sz() {
  source ~/.zshrc
}

# Wrapper for git blatantly copy and pasted from
# https://github.com/wincent/wincent/blob/master/aspects/dotfiles/files/.zsh/functions
# The cool trickery was introduced in this commit to handle edge cases.
# https://github.com/wincent/wincent/commit/a5ba9c0
function git() {
  if [ $# -eq 0 ]; then
    command git status
  elif [ "$1" = root ]; then
    shift
    local ROOT
    if [ "$(command git rev-parse --is-inside-git-dir 2> /dev/null)" = true ]; then
      if [ "$(command git rev-parse --is-bare-repository)" = true ]; then
        ROOT="$(command git rev-parse --absolute-git-dir)"
      else
        # Note: This is a good-enough, rough heuristic, which ignores
        # the possibility that GIT_DIR might be outside of the worktree;
        # see:
        # https://stackoverflow.com/a/38852055/2103996
        ROOT="$(command git rev-parse --git-dir)/.."
      fi
    else
      # Git 2.13.0 and above:
      ROOT="$(command git rev-parse --show-superproject-working-tree 2> /dev/null)"
      if [ -z "$ROOT" ]; then
        ROOT="$(command git rev-parse --show-toplevel 2> /dev/null)"
      fi
    fi
    if [ -z "$ROOT" ]; then
      ROOT=.
    fi
    if [ $# -eq 0 ]; then
      cd "$ROOT"
    else
      (cd "$ROOT" && eval "$@")
    fi
  else
    command git "$@"
  fi
}

# tmux doesn't handle dots in session names
path_name="$(basename "$PWD" | tr . -)"
session_name=${1-$path_name}

function session_exists() {
  tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$session_name$"
}

function not_in_tmux() {
  [[ -z "$TMUX" ]]
}

function create_detached_session() {
  (TMUX='' command tmux new-session -Ad -s "$session_name")
}


function tmux() {
  emulate -LR zsh
  if [ $# -eq 0 ]; then
    if not_in_tmux; then
      echo "creating a new session"
      command tmux new-session -As "$session_name"
    else
      if ! session_exists; then
        echo "creating a detached session"
        create_detached_session
      fi
      echo "switching client"
      command tmux switch-client -t "$session_name"
    fi
  else
    echo "passing args to tmux $@"
    command tmux "$@"
  fi
}

function ensure_tmux_is_running() {
  if not_in_tmux; then
    tmux
  fi
}
