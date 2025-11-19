alias ll='ls -Alh'
alias la='ls -A'
alias l='ls -CF'

alias diff='diff --color -u'

alias df='df -h'

if [ -f /run/.containerenv ]; then
	alias untoolbox='ssh localhost; exit'
fi
