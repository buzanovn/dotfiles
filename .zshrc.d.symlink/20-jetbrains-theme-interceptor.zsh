#!/bin/zsh

# Jetbrains works bad with themes like bulletrain
# We'll try to change the theme to something ASCII-only
# before anitgen is initialized when we are in Jetbrains Terminal
IS_JB_TERMINAL="$(grep 'JetBrains' -o <(echo "$TERMINAL_EMULATOR"))"
if [[ -n "$IS_JB_TERMINAL" ]]; then
    JB_ZSH_THEME="ys"
    export ZSH_NATIVE_THEME="$JB_ZSH_THEME"
    if [[ -n "$ZSH_THEME_PLUGIN" ]]; then
        unset ZSH_THEME_PLUGIN
    fi
fi

