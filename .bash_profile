if [ -f "$HOME/.profile" ]; then
    . "$HOME/.profile"
fi

# Switch to Zsh if interactive (because chsh does not work)
if [ -t 1 ] && [ -x "$(command -v zsh)" ]; then
    export SHELL=$(command -v zsh)
    exec zsh -l
fi

