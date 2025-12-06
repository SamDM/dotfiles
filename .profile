# All code here must be idempotent, because this may be source multiple times

# generally useful
export EDITOR=hx
export COLORTERM=truecolor
export HELIX_RUNTIME=/user/gent/421/vsc42121/vsc_data/Software/helix/runtime

# Add rust/cargo to path
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# Custom software
_USER_BIN_FPATH="$HOME/.local/bin"
case ":$PATH:" in  # Bash case statements work backwards, i.e. haystack in needle
    *":$_USER_BIN_FPATH:"*) ;;           # Already there? Do nothing.
    *) export PATH="$_USER_BIN_FPATH:$PATH" ;;   # Missing? Prepend it.
esac
unset _USER_BIN_FPATH

