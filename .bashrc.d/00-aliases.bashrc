alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias snapshot='sudo btrfs subvolume snapshot / /.snapshots/@snapshot_$(date -Is)'
