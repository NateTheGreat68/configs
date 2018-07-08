#!/bin/bash
#

echo "Installing ~/bin files..."

DIR="$(dirname "$(readlink -f "$0")")"

# make the directory if it doesn't exist
mkdir -p "~/bin"

# copy the files over
cp -rv "$DIR"/../bin/* "$HOME/bin/"
