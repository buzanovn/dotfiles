#!/bin/zsh

# Default tilix fix for VTE
VTE_PROFILE_SH="$(find /etc/profile.d -name 'vte*.sh' | head -n1)"

if { [ -n "$TILIX_ID" ] || [ -n "$VTE_VERSION" ]; } && [ -e "$VTE_PROFILE_SH" ]; then
    source "$VTE_PROFILE_SH"
fi