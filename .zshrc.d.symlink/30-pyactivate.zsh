#!/bin/zsh
CANDIDATES=(".venv" "venv")

function pyactivate() {
	for candidate in "${CANDIDATES[@]}"; do
		local candidate_activate_script="$PWD/$candidate/bin/activate"
		if [[ -f "$candidate_activate_script" ]]; then
			source "$candidate_activate_script"
			return
		fi
	done
}

alias -g pyact="pyactivate"
alias -g pydeact="deactivate"