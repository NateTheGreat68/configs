[[ -z ${PROJECT_HOME+x} ]] && PROJECT_HOME=$HOME/projects

project(){
	# A function to print the usage statement.
	_project_usage(){
		printf \
'usage: %s (<project_name>|-g <git_repo>)
' $1
	}

	# Print the usage statement unless at least one argument is provided.
	[[ $# -lt 1 ]] && _project_usage "${FUNCNAME[0]}" && return 1

	# Determine the project name, and clone from git repo if appropriate.
	if [[ "$1" == "-g" ]]; then
		if [[ -f "$2" ]]; then
			# Cloning from a bundle
			proj_name=$(echo "$2" | sed -e 's|/*\.bundle$||' -e 's|.*/||g')
		else
			proj_name=$(echo "$2" |
				sed -e 's|/$||' -e 's|:*/*\.git$||' -e 's|.*[/:]||g')
		fi
		git clone "$2" "$PROJECT_HOME/$proj_name"
	else
		proj_name="$1"
	fi

	# Detach the client if it's currently attached.
	# First, save the project name to the next file.
	if [[ -n "$TMUX" ]]; then
		current_session="$(tmux display-message -p '#S')"
		echo "$proj_name" > "$PROJECT_HOME/.projectscripts/$current_session.next"
		tmux detach-client
		return 0
	fi

	# Execute global and project-specific enter scripts.
	# This is used to run a toolbox, ssh into another machine, etc.
	# Return values from the scripts are binary-encoded.
	# 1 will exit the script.
	# 2 will prevent the global enter script from being run.
	# 4 will prevent the tmux session from being started - for remote ssh, etc.
	skip_global_script=0
	skip_tmux_session=0
	if [[ -f "$PROJECT_HOME/.projectscripts/$proj_name.enter" ]]; then
		. "$PROJECT_HOME/.projectscripts/$proj_name.enter"
		result=$?
		if [[ $(( $result & 1 )) -eq 1 ]]; then
			return 0
		fi
		if [[ $(( $result & 2 )) -eq 2 ]]; then
			skip_global_script=1
		fi
		if [[ $(( $result & 4 )) -eq 4 ]]; then
			skip_tmux_session=1
		fi
	fi
	if  [[ -f "$PROJECT_HOME/.projectscripts/enter" ]] && \
		[[ $skip_global_script -eq 0 ]]; then
		. "$PROJECT_HOME/.projectscripts/enter" "$proj_name"
		result=$?
		if [[ $(( $result & 1 )) -eq 1 ]]; then
			return 0
		fi
		if [[ $(( $result & 4 )) -eq 4 ]]; then
			skip_tmux_session=1
		fi
	fi

	# Create the session (if necessary) and attach to it.
	echo "TMUX: $TMUX" >> ~/test
	if [[ $skip_tmux_session -eq 0 ]]; then
		tmux -L "$proj_name" new-session -A -s "$proj_name" \
			-c "$PROJECT_HOME/$proj_name" 2> /dev/null
	fi

	# Execute global and project-specific exit scripts.
	# Return values from the scripts are binary-encoded.
	# 1 will exit the script.
	# 2 will prevent the global exit script from being run.
	skip_global_script=0
	if [ -f "$PROJECT_HOME/.projectscripts/$proj_name.exit" ]; then
		. "$PROJECT_HOME/.projectscripts/$proj_name.exit"
		result=$?
		if [[ $(( $result & 1 )) -eq 1 ]]; then
			return 0
		fi
		if [[ $(( $result & 4 )) -eq 4 ]]; then
			skip_global_script=1
		fi
	fi
	if  [[ -f "$PROJECT_HOME/.projectscripts/exit" ]] && \
		[[ $skip_global_script -eq 0 ]]; then
		. "$PROJECT_HOME/.projectscripts/exit" "$proj_name"
		result=$?
		if [[ $(( $result & 1 )) -eq 1 ]]; then
			return 0
		fi
	fi

	# If a defining file is present, run the specified project.
	if [[ -f "$PROJECT_HOME/.projectscripts/$proj_name.next" ]]; then
		next_proj="$(cat "$PROJECT_HOME/.projectscripts/$proj_name.next")"
		rm "$PROJECT_HOME/.projectscripts/$proj_name.next"
		project "$next_proj"
	fi
}
export project

# Set up tab completion.
_project_completion(){
	_project_dirs(){
		# Follow symlinks, only find directories, don't include hidden basenames
		find -L "$PROJECT_HOME" -maxdepth 1 -mindepth 1 -type d ! -name '.*' -printf '%f\n'
	}

	COMPREPLY=($(compgen -W "$(_project_dirs)" "${COMP_WORDS[COMP_CWORD]}"))
}
complete -o nospace -F _project_completion project
