#!/bin/zsh

_HOME_DIR="$(getent passwd "$USER" | cut -d: -f6)"
DOTFILES_DIR="${_HOME_DIR}/.dotfiles"

if [[ ! -e "$DOTFILES_DIR" ]]; then 
    mkdir -p "$(dirname "$DOTFILES_DIR")"
    git clone --depth=1 https://github.com/buzanovn/dotfiles.git "$DOTFILES_DIR"
else
    read -r "perform_update?dotfiles directory already exists, do you want to pull changes from the remote? (Y/N) " || perform_update="y"
    if [[ $perform_update != [Yy] && $perform_update != [Yy][Ee][Ss] ]]; then
        echo "You answered '${perform_update}', exiting..."
        exit 0
    fi
    git -C "$DOTFILES_DIR" pull
fi

source "$DOTFILES_DIR/install-dotfiles"
