#!/bin/zsh

_HOME_DIR="$(getent passwd "$USER" | cut -d: -f6)"
DOTFILES_DIR="${_HOME_DIR}/.dotfiles"

if [[ ! -e "$DOTFILES_DIR" ]]; then 
    mkdir -p "$(dirname "$DOTFILES_DIR")"
    git clone --depth=1 https://github.com/buzanovn/dotfiles.git "$DOTFILES_DIR"
fi

source "$DOTFILES_DIR/install-dotfiles"
