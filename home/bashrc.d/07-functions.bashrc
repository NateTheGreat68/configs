swap_files(){
	t="$(mktemp -p "$(dirname "$1")")" || return 1
	mv -f "$1" "$t"
	mv -f "$2" "$1"
	mv -f "$t" "$2"
}
export swap_files
