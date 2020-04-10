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
# Variable exports
#-------------------------------------------------------------------------------

# Since I do a tty login and then start i3 with startx, the `.zshrc` config
# will be sourced first before any other such as `.xinitrc`, `.profile`, etc.
# Therefore, this is the most 'global' place to export variables.
export PATH=~/.local/bin:$PATH

# enable snap packages
# emulate sh -c 'source /etc/profile.d/apps-bin-path.sh'

# Enables colors and italics in neovim
export EDITOR=nvim

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

function conda_env {
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
        echo ' %F{34}`-._.-'"''"'-:>%f%F{160}~%f '"$CONDA_DEFAULT_ENV "
    fi
}

function zle-line-init zle-keymap-select {
    PRE=$'%F{159}╭%n@%M:%L %30<...<%~%<<% %f %F{223}❖%f %F{159}%w %T%f %(?..%F{125}✘%?%f )%(1j.%F{215}::%j.%f)\n'
    MOD="%F{159}╰%f$(conda_env)${${KEYMAP/vicmd/%F{198\}X%f }/(main|viins)/%F{223\}$%f }"
    PS1=$PRE$MOD
    zle reset-prompt
}
# ```

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

# Use vim as a pager
alias vip='nvim -R -'
# Easily launch a desktop app as a child process of the ?? thread from within
# the terminal
alias opn='xdg-open'

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

