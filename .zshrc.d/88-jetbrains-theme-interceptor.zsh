#/!bin/bash

# Jetbrains works bad with themes like bulletrain
# We'll try to change the theme to something ASCII-only
# before anitgen is initialized when we are in Jetbrains Terminal
IS_JB_TERMINAL="$(grep 'JetBrains' -o <(echo $TERMINAL_EMULATOR))"
if [[ -n "$IS_JB_TERMINAL" ]]; then
    if [[ -z "$ZSH_DEFAULT_ASCII_THEME" ]]; then
        JB_ZSH_THEME="ys"
    else
        JB_ZSH_THEME="$ZSH_DEFAULT_ASCII_THEME"
    fi
    export ZSH_THEME="$JB_ZSH_THEME"
fi

