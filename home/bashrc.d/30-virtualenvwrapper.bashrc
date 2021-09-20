export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects
source /usr/share/virtualenvwrapper/virtualenvwrapper.sh

if [[ $VIRTUAL_ENV ]]; then
	workon "$(basename "$VIRTUAL_ENV")"
else
	for project in $(virtualenvwrapper_show_workon_options); do
		[[ "$(readlink -f "$PWD")" == "$(readlink -f "$(cat "$WORKON_HOME/$project/.project")")" ]] && workon "$project"
	done
fi
