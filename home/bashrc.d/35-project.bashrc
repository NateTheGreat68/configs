[[ -z ${PROJECT_HOME+x} ]] && PROJECT_HOME=$HOME/projects

project(){
	_project_usage(){
		printf \
'usage: %s <project_name>
' $1
	}

	[[ $# -ne 1 ]] && _project_usage "${FUNCNAME[0]}" && return 1

	tmux new-session -ds "$1" -c "$PROJECT_HOME/$1" 2> /dev/null
	if [[ $TMUX ]]; then
		tmux switch-client -t "$1"
	else
		tmux attach-session -t "$1"
	fi
}
export project

_project_completion(){
	_project_dirs(){
		for filename in $(ls $PROJECT_HOME); do
			[[ -d "$PROJECT_HOME/$filename" ]] && echo $filename
		done
	}

	COMPREPLY=($(compgen -W "$(_project_dirs)" "${COMP_WORDS[COMP_CWORD]}"))
}
complete -o nospace -F _project_completion project
