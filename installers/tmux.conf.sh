#!/bin/bash
#

echo "Installing tmux.conf configs..."

DIR="$(dirname "$(readlink -f "$0")")"

# make the directory if it doesn't exist
[ -d "$HOME/.configs" ] || mkdir "$HOME/.configs"

# copy the files over
cp -v "$DIR"/../tmux_* "$HOME/.configs/"

# check if .vimrc exists
if [ ! -f "$HOME/.tmux.conf" ]; then
    cat "$DIR/tmux.conf" >> "$HOME/.tmux.conf"
else
    # add vimrc lines if they aren't already there
    grep -Fxq "$(cat "$DIR/tmux.conf")" "$HOME/.tmux.conf" || cat "$DIR/tmux.conf" >> "$HOME/.tmux.conf"
fi
