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

#-------------------------------------------------------------------------------
# Plugins
#-------------------------------------------------------------------------------

# Load zsh-autosuggestions.
source /usr/share/zsh/plugins/zsh-autosuggestions/autosuggestions.zsh

# Accept suggestions without leaving insert mode
bindkey '^f' vi-forward-word
bindkey '^T' autosuggest-execute-suggestion

# Starting the autosuggest is done in the promptline function, this is a bit
# ugly. I should find some way to split this out in two parts that work
# independently

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

# Required for color codes to work in prompt
export TERM="xterm-256color"

function zle-line-init zle-keymap-select {
    PRE=$'%F{15}%M-%n-%L%f %F{15}%30<...<%~%<<%f%F{236} ❖ %f%F{15}%w %T%f%F{7} %f%(?..%F{125}✘%?%f)\n'
    MOD="${${KEYMAP/vicmd/%F{198\}⚡%f }/(main|viins)/%F{87\}⚡%f }"
    PS1=$PRE$MOD
    zle reset-prompt

    # Enable autosuggestions automatically.
    zle autosuggest-start
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
alias oldvim='/usr/bin/vim'
alias vim='nvim'
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
alias grep='grep --color=auto'
alias tmux='tmux -2' # start tmux in full 256 color mode

# Shortcuts and random stuff
alias partinfo='lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT,UUID,LABEL,PARTUUID,PARTTYPE'
alias perlconsole='perl -de 0'
alias clearpackcache='paccache -ruk0 && paccache -ruk0'
alias listvimplugins='pacman -Qs vim-plugins | grep vim-plugins | cut -d/ -f2 | sed "s/ (.*)//g"'

# Start apache server
alias startapache='sudo systemctl start httpd'
# Start mysql server
alias startmysql='sudo systemctl start mysqld.service'
# List all files tracked by git
alias gittracked='git ls-tree -r master --name-only'

# Use vim as a pager
alias vip='vim -R -'
# Easily launch a desktop app as a child process of the ?? thread from within
# the terminal
alias opn='xdg-open'

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
