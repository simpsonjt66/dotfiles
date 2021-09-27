#!/bin/bash
function zsh-stats() {
  # fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n25
  # history -100000 | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
  history 0 $HISTSIZE | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}

# sources .zshrc
function sz() {
  # shellcheck disable=SC1091
  source "$HOME"/.zshrc
  echo "/.zshrc reloaded"
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
      cd "$ROOT" || exit
    else
      (cd "$ROOT" && eval "$@")
    fi
  else
    command git "$@"
  fi
}
