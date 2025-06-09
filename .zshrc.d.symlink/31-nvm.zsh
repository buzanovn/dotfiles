#!/bin/zsh

NVM_DIR="$HOME/.nvm"
if [[ -d $NVM_DIR ]]; then
    export NVM_DIR
    [ -s "$NVM_DIR/nvm.sh" ] && zsh-defer \. "$NVM_DIR/nvm.sh"
fi