alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias diff='diff --color -u'

if [ -f /run/.containerenv ]; then
	alias untoolbox='ssh localhost; exit'
fi
