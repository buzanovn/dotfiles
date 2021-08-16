#!/bin/zsh

function __complete_ssh() {
    local state;
    _arguments \
        "1: :->host"
        "*: :->anythingelse"
    case "$state" in
        (host) 
            local -a h
            if [[ -r ~/.ssh/config ]]; then
                h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
            fi
            _describe 'command' h
        ;;
    esac
}

compdef __complete_ssh ssh
compdef __complete_ssh scp 
compdef __complete_ssh slogin