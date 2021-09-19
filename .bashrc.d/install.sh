#!/bin/bash

if ! (cat ~/.bashrc | egrep "#bashrc.d_installed") &> /dev/null ; then
	printf \
'
#bashrc.d_installed
for file in ~/.bashrc.d/*.bashrc ; do
	source "$file"
done
' >> ~/.bashrc
fi
