alias ll='ls -lh'
alias la='ls -A'
alias lal='ls -Alh'
alias l='ls -CF'

alias diff='diff --color -u'

alias df='df -h'

if [ -f /run/.containerenv ]; then
	alias untoolbox='ssh localhost; exit'
fi
