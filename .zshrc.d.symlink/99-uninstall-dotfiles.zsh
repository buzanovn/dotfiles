#!/bin/zsh

function uninstall_dotfiles() {
    for installable in $(cat /home/$USER/.cache/dotfiles/installables); do
        if [ -L $installable ]; then 
            unlink $installable
        fi
    done
    rm /home/$USER/.cache/dotfiles/installables
}