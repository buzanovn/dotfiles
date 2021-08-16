#!/bin/zsh

VENVS_PATH="$HOME/.venvs"

function pyactivate() { 
    source "$1/bin/activate"
} 

function __complete_pyactivate() {
	local state

	_arguments \
		'1: :->directory' \
		'*: :->anythingelsedoesnotmatterwhat'

	case "$state" in
		(directory) 
			local -a commands;
			for gd in $(echo "$VENVS_PATH" | grep -o -e "[^:]*"); do
				for d in $gd/*; do
					if [[ -d $d && -d $d/bin ]]; then
						name="$(basename $d)"
						version="version $(echo $($d/bin/python --version) | cut -d' ' -f2) @ $d"
						commands+=("$name:$version")
					fi
				done
			done
			_describe 'command' commands
		;;
	esac
}

compdef __complete_pyactivate pyactivate