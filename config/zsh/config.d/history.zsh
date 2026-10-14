# --- 1. Core Storage Limits ---
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=$XDG_STATE_HOME/zsh/history

# --- 2. Optimized History Options ---
setopt append_history         # Safely append to the history file
setopt extended_history       # Saves timestamp data (highly recommended)
setopt share_history          # Share history instantly across windows (REMOVED inc_append_history to stop conflicts)
setopt hist_verify            # Don't execute immediately upon history expansion

# --- 3. Clean Duplicates Safely ---
setopt hist_ignore_all_dups   # Erase old duplicate commands completely when a new one is typed
setopt hist_save_no_dups      # Ensures duplicates are never written out to the physical disk
setopt hist_ignore_space      # Don't record lines starting with a space
setopt hist_find_no_dups      # When searching backwards, don't show the same command twice

