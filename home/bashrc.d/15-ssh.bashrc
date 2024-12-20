ssh(){
	case $(ssh-add -L &> /dev/null; echo $?) in
		2)
			eval `ssh-agent`
			ssh-add
			;;
		1)
			ssh-add
			;;
	esac
	/usr/bin/env ssh $@
}
export ssh
