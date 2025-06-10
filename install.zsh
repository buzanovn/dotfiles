#!/bin/zsh

_HOME_DIR="$(getent passwd "$USER" | cut -d: -f6)"
DOTFILES_DIR="${_HOME_DIR}/.dotfiles"

if [[ ! -e "$DOTFILES_DIR" ]]; then 
    mkdir -p "$(dirname "$DOTFILES_DIR")"
    git clone --depth=1 https://github.com/buzanovn/dotfiles.git "$DOTFILES_DIR"
else
    default_response='Y'
    read -r "response?dotfiles directory already exists, do you want to pull changes from the remote? [Y/n]"
    response=${response:-$default_response}
    if [[ $response != [Yy] && $response != [Yy][Ee][Ss] ]]; then
        echo "You answered '${response}', exiting..."
        exit 0
    fi
    git -C "$DOTFILES_DIR" pull
fi

source "$DOTFILES_DIR/install-dotfiles"
