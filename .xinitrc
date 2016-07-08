# Start the compositor (provides transparency, fading and vsync) as a
# non-blocking process
compton -G -D 5 -O 0.07 -I 0.07 --vsync opengl &
# `startx` executes `xinit` which in turn executes the `~/.xinitrc` file (this
# file). The X session will be set up before executing the script. The X
# session ends when the `~/.xinitrc` script is finished. The exit status of the
# exec command below is probably the exit status of startx.
exec i3
