port () {
	sudo lsof -nP -iTCP:$1 -sTCP:LISTEN	
}

alias dcu='docker-compose up'
alias dcd='docker-compose down'
