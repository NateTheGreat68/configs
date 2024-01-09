[[ -z ${PROJECT_HOME+x} ]] && PROJECT_HOME=$HOME/projects

project(){
	_project_usage(){
		printf \
'usage: %s (<project_name>|-g <git_repo>)
' $1
	}

	[[ $# -lt 1 ]] && _project_usage "${FUNCNAME[0]}" && return 1

	if [[ "$1" = "-g" ]]; then
		if [[ -f "$2" ]]; then
			# Cloning from a bundle
			proj_name=$(echo "$2" | sed -e 's|/*\.bundle$||' -e 's|.*/||g')
		else
			proj_name=$(echo "$2" |
				sed -e 's|/$||' -e 's|:*/*\.git$||' -e 's|.*[/:]||g')
		fi
		git clone "$2" "$PROJECT_HOME/$proj_name"
	else
		proj_name=$1
	fi

	tmux new-session -ds "$proj_name" -c "$PROJECT_HOME/$proj_name" 2> /dev/null
	if [[ -n $TMUX ]]; then
		tmux switch-client -t "$proj_name"
	else
		tmux attach-session -t "$proj_name"
	fi
}
export project

_project_completion(){
	_project_dirs(){
		# Follow symlinks, only find directories, don't include hidden basenames
		find -L "$PROJECT_HOME" -maxdepth 1 -type d ! -name '.*' -printf '%f\n'
	}

	COMPREPLY=($(compgen -W "$(_project_dirs)" "${COMP_WORDS[COMP_CWORD]}"))
}
complete -o nospace -F _project_completion project
