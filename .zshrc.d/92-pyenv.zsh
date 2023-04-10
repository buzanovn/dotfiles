#!/bin/zsh

PYENV_ROOT="$HOME/.pyenv"
PYENV_EXECUTABLE="$(command -v pyenv >/dev/null)"

if [ -z "${PYENV_EXECUTABLE}" ]; then
    _zsh_log 'No pyenv executable found in PATH, looking for a file'
    PYENV_EXECUTABLE="${PYENV_ROOT}/bin/pyenv"
    if [ ! -f "${PYENV_EXECUTABLE}" ]; then
        _zsh_log 'No pyenv executable found at all, termintating this script'
        exit 0
    fi
fi

export PYENV_ROOT="${PYENV_ROOT}"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$($PYENV_EXECUTABLE init -)"
eval "$($PYENV_EXECUTABLE virtualenv-init -)"
