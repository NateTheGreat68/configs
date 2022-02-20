ssh-key(){
	eval $(ssh-agent)
	ssh-add "$@"
}
