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
# Variable exports
#-------------------------------------------------------------------------------

# Since I do a tty login and then start i3 with startx, the `.zshrc` config
# will be sourced first before any other such as `.xinitrc`, `.profile`, etc.
# Therefore, this is the most 'global' place to export variables.
export PATH=/home/sam/.local/bin:/home/sam/Executable:$PATH

# For i3: make apps follow the qt5ct theme
export QT_QPA_PLATFORMTHEME="qt5ct"

# Enables colors and italics in neovim
export NVIM_TUI_ENABLE_TRUE_COLOR=1
export EDITOR=nvim

# Required for color codes to work in prompt
export TERM=st-256color

#-------------------------------------------------------------------------------
# Prompt
#-------------------------------------------------------------------------------

# ```
function zle-line-init zle-keymap-select {
    PRE=$'%F{15}%M-%n-%L%f %F{15}%30<...<%~%<<%f%F{236} ❖ %f%F{15}%w %T%f%F{7} %f%(?..%F{125}✘%?%f )%(1j.%F{215}::%j.%f)\n'
    MOD="${${KEYMAP/vicmd/%F{198\}⚡%f }/(main|viins)/%F{87\}⚡%f }"
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

# # In i3 the dolphin app has no icons because it wants to use the current
# # desktop theme, and i3 has none. This tricks dolphin into thinking it runs in
# # Gnome, so it nicely follows my gtk/lxappearnce settings. Don't forget to also
# # modife the dolphin desktop file.
# # To do so:
# # ```
# # mkdir ~/.local/share/applications
# # cd ~/.local/share/applications
# # cp /usr/share/applications/org.kde.dolphin.desktop .
# # ```
# # And change the `Exec` line to:
# # ```
# # Exec=XDG_CURRENT_DESKTOP=GNOME dolphin %u
# # ```
# alias dolphin='XDG_CURRENT_DESKTOP=GNOME dolphin'

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
