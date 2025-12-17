path_prepend() {
    # 1. Check if the directory actually exists
    if [ -d "$1" ]; then
        # 2. Use the case statement to check for the path surrounded by colons
        case ":$PATH:" in
            *":$1:"*) ;;              # Already there? Do nothing.
            *) export PATH="$1:$PATH" ;;  # Missing? Prepend it.
        esac
    fi
}

path_prepend "/usr/local/cuda/bin"
path_prepend "$HOME/.local/bin"

# Add rust/cargo to path
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
