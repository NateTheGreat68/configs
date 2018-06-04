#!/bin/bash
#

echo "Installing bashrc configs..."

DIR="$(dirname "$(readlink -f "$0")")"

# make the directory if it doesn't exist
[ -d "$HOME/.configs" ] || mkdir "$HOME/.configs"

# copy the files over
cp -v "$DIR"/../bash_* "$HOME/.configs/"

# check if .bashrc exists
if [ ! -f "$HOME/.bashrc" ]; then
    cat "$DIR/bashrc" >> "$HOME/.bashrc"
else
    # add bashrc lines if they aren't already there
    grep -Fxq "$(tail -n 1 "$DIR/bashrc")" "$HOME/.bashrc" || cat "$DIR/bashrc" >> "$HOME/.bashrc"
fi
