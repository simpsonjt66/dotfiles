function tmux() {
  emulate -LR zsh

  if [ $# -eq 0 ]; then
    if [ -x .tmux ]; then
      ./.tmux
      return
    fi

    local session_name=${1-"$(basename "$PWD" | tr . -)"}

    if [[ ! $(pgrep tmux) ]]; then
      command tmux new -ds "$session_name"
    elif ! $(command tmux has-session -t="$session_name"); then
      command tmux new -ds "$session_name"
    fi
    if [[ "$TMUX" ]]; then
      command tmux switch-client -t="$session_name"
    else
      command tmux attach -t="$session_name"
    fi
  else
    command tmux "$@"
  fi
}
