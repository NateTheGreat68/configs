#!/bin/bash
#

echo "Installing vimrc configs..."

DIR="$(dirname "$(readlink -f "$0")")"

# make the directory if it doesn't exist
[ -d "$HOME/.configs" ] || mkdir "$HOME/.configs"

# copy the files over
cp -v "$DIR"/../vim_* "$HOME/.configs/"

# check if .vimrc exists
if [ ! -f "$HOME/.vimrc" ]; then
    cat "$DIR/vimrc" >> "$HOME/.vimrc"
else
    # add vimrc lines if they aren't already there
    grep -Fxq "$(tail -n 3 "$DIR/vimrc" | head -n 1)" "$HOME/.vimrc" || cat "$DIR/vimrc" >> "$HOME/.vimrc"
fi
