#-------------------------------------------------------------------------------
# Set env
#-------------------------------------------------------------------------------

if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

#-------------------------------------------------------------------------------
# General options
#-------------------------------------------------------------------------------

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
# already does 'setopt inc_append_history'
setopt share_history

# suggests corrections to incorrectly typed commands
setopt correct
# allows bash-style comments in interactive shell
setopt interactivecomments

# use vi mode
bindkey -v

# start zsh completion engine
autoload -Uz compinit
compinit

#-------------------------------------------------------------------------------
# keybindings
#-------------------------------------------------------------------------------

# History options
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '\eOA' up-line-or-beginning-search
bindkey '\e[A' up-line-or-beginning-search
bindkey '\eOB' down-line-or-beginning-search
bindkey '\e[B' down-line-or-beginning-search
bindkey '^k'   up-line-or-beginning-search
bindkey '^j'   down-line-or-beginning-search
bindkey '^r'   history-incremental-search-backward


# Can't function without this
bindkey -M viins 'jj' vi-cmd-mode

# Push the current command to the stack and return the prompt, the next prompt
# after this will then automatically pop it back of the stack, ready to use
bindkey '^x' push-input

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------

# Some common options
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
alias grep='grep --color=auto'

# Shortcuts and random stuff
alias partinfo='lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,UUID,LABEL,PARTUUID,PARTTYPE'

# Test if terminal is truecolor or not
function terminaltest {
  awk 'BEGIN{
  s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
  for (colnum = 0; colnum<77; colnum++) {
      r = 255-(colnum*255/76);
      g = (colnum*510/76);
      b = (colnum*255/76);
      if (g>255) g = 510-g;
      printf "\033[48;2;%d;%d;%dm", r,g,b;
      printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
      printf "%s\033[0m", substr(s,colnum+1,1);
  }
  printf "\n";
  }'
  echo -e "\e[1mbold\e[0m"
  echo -e "\e[3mitalic\e[0m"
  echo -e "\e[4munderline\e[0m"
  echo -e "\e[9mstrikethrough\e[0m"
}

# Opens a temp R file in the current dir
# Pre loaded with tidyverse :)
function rHere {
  FILENAME=$(date | sed 's/ \+/-/g' | sed 's/:/h/'| sed 's/:/m/' | sed 's/\(.*\)/rHere_\1.R/')
  FILEPATH="/tmp/$FILENAME"
  CWD=$(pwd)
  echo "setwd('${CWD}')\nlibrary(tidyverse)" >> $FILEPATH
  nvim $FILEPATH
}

# auto-ignore huge git directory
alias tree='tree -I .git'

alias tmux='module load tmux; tmux'

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

eval "$(starship init zsh)"
