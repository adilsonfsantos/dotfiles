#!/usr/bin/env zsh

zlog() {
	local level="${1:-INFO}"; shift
	local RESET=$'\e[0m'
	local color=$RESET

	case "$level" in
		INFO)	color=$(tput setaf 6) ;; # cyan
		OK)		color=$(tput setaf 2) ;; # green
		AVISO)	color=$(tput setaf 3) ;; # yellow
		ERRO)	color=$(tput setaf 1) ;; # red
	esac

	if [[ $level == ERR ]]; then
		echo "${color}[$(date +'%H:%M:%S')][$level] $*${RESET}" >&2
	else
		echo "${color}[$(date +'%H:%M:%S')][$level] $*${RESET}"
	fi
}

