#!/bin/zsh

VENVS_PATH="$HOME/.venvs"

function get_python_version {
	local binary="$1"
	echo $($binary --version) | cut -d' ' -f2
}

function list_python_version() {
	local -a versions
	for p in /usr/bin; do
		for f in $(find $p -type f 2>/dev/null | grep -P "python($|([0-9].?)+)"); do
			versions+=("$(get_python_version $f)")
		done
	done
	echo "${(u)versions[@]}"
}

function find_python_binary() {
	local version="$1"
	for p in /usr/bin; do
		for f in $(find $p -type f 2>/dev/null | grep -P "python($|([0-9].?)+)"); do
			if [[ "$(get_python_version $f)" = "$version" ]]; then
				echo $f;
				return;
			fi
		done
	done
}

function pyactivate() { 
    source "$1/bin/activate"
}

function pycreate() {
	local version="$1"
	local name="$2"
	local binary="$(find_python_binary $version)"
	if [[ -d "$VENVS_PATH/$name" ]]; then
		echoerr 'Venv already exists'
	fi
	python3 -m virtualenv "$VENVS_PATH/$name" --python "$binary"
}

function __complete_pycreate() {
	local state

	_arguments \
		'1: :->version' \
		'2: :->name'
	
	case "$state" in
		(version)
			compadd $(list_python_version)
		;;
	esac
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
compdef __complete_pycreate pycreate