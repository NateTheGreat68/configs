export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

if [[ $VIRTUAL_ENV ]]; then
	workon "$(basename "$VIRTUAL_ENV")"
fi
