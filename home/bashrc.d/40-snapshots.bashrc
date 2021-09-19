snapshot(){
	local snapshot_name="/.snapshots/@snapshot_$(date -Is)"
	sudo btrfs subvolume snapshot / "$snapshot_name"
	sudo ln -sfn "$snapshot_name" "/.snapshots/latest"
}
