#-------------------------------------------------------------------------------
# General options
#-------------------------------------------------------------------------------

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt share_history # already does 'setopt inc_append_history'
setopt correct
bindkey -v
zstyle :compinstall filename '/home/sam/.zshrc'
autoload -Uz compinit
compinit

export PATH=/home/sam/.local/bin:/home/sam/Executable:$PATH

# Enables colors and italics in neovim
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export EDITOR=nvim

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

# Required for color codes to work in prompt
#export TERM=screen-256color
export TERM=st-256color

function zle-line-init zle-keymap-select {
    PRE=$'%F{15}%M-%n-%L%f %F{15}%30<...<%~%<<%f%F{236} ❖ %f%F{15}%w %T%f%F{7} %f%(?..%F{125}✘%?%f )%(1j.%F{215}::%j.%f)\n'
    MOD="${${KEYMAP/vicmd/%F{198\}⚡%f }/(main|viins)/%F{87\}⚡%f }"
    PS1=$PRE$MOD
    zle reset-prompt

}

zle -N zle-line-init
zle -N zle-keymap-select

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
alias perlconsole='perl -de 0'
alias clearpackcache='sudo paccache -r && sudo paccache -ruk0'
alias listvimplugins='pacman -Qs vim-plugins | grep vim-plugins | cut -d/ -f2 | sed "s/ (.*)//g"'

# Start apache server
alias startapache='sudo systemctl start httpd'
# Start mysql server
alias startmysql='sudo systemctl start mysqld.service'
# List all files tracked by git
alias gittracked='git ls-tree -r master --name-only'

# Use vim as a pager
alias vip='nvim -R -'
# Easily launch a desktop app as a child process of the ?? thread from within
# the terminal
alias opn='xdg-open'

# Turn pc into WiFi hotspot
alias hotspot-whoson='create_ap --list-clients $(create_ap --list-running | tail -n1 | awk "{print $1}")'
alias hotspot-running='create_ap --list-running'

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

#===============================================================================
# Disabled options
#===============================================================================

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

# Use powerline (powerline symbols cause spacing problems in urxvt)
#powerline-daemon -q
#. /usr/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh

# . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .

# Or use fancy prompt
# must be called every time input mode changes

# Fancy prompt option 1
#function zle-line-init zle-keymap-select {
    #PRE=$'%F{222}┌─❮%f%F{159}%M-%n-%L%f %F{75}%30<...<%~%<<%f%F{222}❯─❮%f%F{159}%w %*%f%F{222}❯─❮%f%(?.%F{002}✔%f.%F{196}✘%f):%F{015}%?%f%F{222}❯\n└%f'
    #MOD="%F{222}${${KEYMAP/vicmd/─∷}/(main|viins)/─╸}%f"
    #PS1=$PRE$MOD
    #zle reset-prompt
#}

# Fancy prompt option 2
#function zle-line-init zle-keymap-select {
    #PRE=$'%F{44}┌❮%f%F{159}%M-%n-%L%f %F{123}%30<...<%~%<<%f%F{44}❯ ❮%f%F{159}%w %*%f%F{44}❯ ❮%f%(?.%F{43}✔%f.%F{125}✘%f):%F{159}%?%f%F{44}❯\n└%f'
    #MOD="%F{44}${${KEYMAP/vicmd/∷}/(main|viins)/╸}%f"
    #PS1=$PRE$MOD
    #zle reset-prompt
#}
#zle -N zle-line-init
#zle -N zle-keymap-select

#-------------------------------------------------------------------------------
# Aliases
#-------------------------------------------------------------------------------

# Ultra-retro kathode tube
#alias go-retro='cool-retro-term --fullscreen --profile '"'"'Amber'"'"' -e tmux > /dev/null 2>&1 &'
# Add current mpd song to a playlist (rating or playlist name)
#alias rate='/home/sam/.ncmpcpp/ratemusic'
