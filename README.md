# configs

Basic configuration files for setting up my environmental preferences on a new Linux install, since I seem to do it so often for some reason.

## Basic Setup

The configs currently available are for bash, vim, and tmux (and readline, via inputrc). To install: clone the repo, cd do its root, and do:
```
$ ./install.sh
```

This will create a ~/.bashrc.d, ~/.vimrc.d, ~/.tmux.conf.d/, and ~/.inputrc.d directories and populate them with the individual config files, then add references to those files in the ~/.bashrc, ~/.vimrc, ~/.tmux.conf, and ~/.inputrc files, respectively.
Be aware that any changes you make to these files will be clobbered by the installer.

## Additional Requirements

Don't forget to install python3's virtualenv and virtualenvwrapper packages. In Debian:
```
# apt update
# apt install python3-pip python3-virtualenv python3-virtualenvwrapper
```
