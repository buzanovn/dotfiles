#!/bin/zsh

function download_antigen { 
  if [[ ! -e $ZSH_ANTIGEN_PATH ]]; then
    local antigen_url="git.io/antigen"
    echoerr "Error: Antigen not found, installing it from git.io/antigen"
    mkdir -p $(dirname $ZSH_ANTIGEN_PATH)
    if [[ -n "$(command -v curl)" ]]; then 
      curl -fsSL $antigen_url > $ZSH_ANTIGEN_PATH
    elif [[ -n "$(command -v wget)" ]]; then 
      wget $antigen_url -qO $ZSH_ANTIGEN_PATH
    else
      echoerr "Error: Neither curl nor wget were found, can not download antigen"
      USE_ANTIGEN=false
    fi
  fi
}

function update_antigen {
  if [[ -e $ZSH_ANTIGEN_PATH ]]; then 
  	mv $ZSH_ANTIGEN_PATH $ZSH_ANTIGEN_PATH.bak
  fi
  download_antigen
}

download_antigen
if [[ "$USE_ANTIGEN" = false ]]; then
  echoerr "No antigen found, exiting"
  exit 
fi

source $ZSH_ANTIGEN_PATH
antigen use oh-my-zsh
antigen theme ${ZSH_THEME}

antigen bundles <<EOBUNDLES
  git
  pip
  docker
  command-not-found
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-autosuggestions
EOBUNDLES

case $DISTRNAME in 
  ubuntu) 
    antigen bundle ubuntu
    ;;
esac

antigen apply

case "$ZSH_THEME" in 
    *powerlevel10k)
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    ;;
  *spaceship)
    export SPACESHIP_DOCKER_SHOW=false
    ;;
esac


