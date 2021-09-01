#!/bin/zsh

_zsh_session_id="$(date +%s%3N)"

function echoerr() { 
  tput setaf 1; 
  echo "$@" 1>&2;
}

function _zsh_log() {
  echo "[${_zsh_session_id}] [$(date '+%Y-%m-%d %H:%M:%S')] $@" >> "/home/${USER}/.zshrc-log"
}

function _zsh_log_var() {
  local varname="$1"
  _zsh_log "${varname} = ${(P)varname}"
}