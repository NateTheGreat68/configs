#!/bin/bash
#

DIR="$(dirname "$(readlink -f "$0")")"

"$DIR"/bashrc.sh
"$DIR"/bin.sh
"$DIR"/tmux.conf.sh
"$DIR"/vimrc.sh
