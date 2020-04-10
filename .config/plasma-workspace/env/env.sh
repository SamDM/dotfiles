# Doesn't work when I put it in '~/.config/plasma-workspace/env/env.sh'.
# But it does work when I just source it, both from bash and zsh.
# source /etc/profile.d/apps-bin-path.sh

# enables snap packages
export PATH=$PATH:/snap/bin
export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/snapd/desktop

export KDE_STARTUP_TEST=test_done
