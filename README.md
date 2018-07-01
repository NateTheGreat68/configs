# configs

Basic configuration files for setting up my environmental preferences on a new Linux install, since I seem to do it so often for some reason.

## Basic Setup

The configs currently available are for bash, vim, and tmux. To install: clone the repo, cd do its root, and do:
```
$ ./installers/bashrc.sh
$ ./installers/vimrc.sh
$ ./installers/tmux.conf.sh
```

This will create a ~/.configs directory and populate it with the individual config files, then add references to those files in the ~/.bashrc, ~/.vimrc, ~/.tmux.conf files, respectively.
Be aware that any changes you make to these files will be clobbered by the installer; I usually tweak the config files in ~/.configs, then copy them to the git repo directory to make sure I don't lose my changes.

## Additional Requirements

To use everything included here (specifically the bash `proj` command), you'll also need python's (I recommend python3's) virtualenv and virtualenvwrrapper packages. To install in a recent-ish Debian system:
```
# apt-get update
# apt-get install python3-pip
# pip3 install virtualenv
# pip3 install virtualenvwrapper
```
Make a projects directory in your home (`$ mkdir ~/projects`) and you should be good to go!
