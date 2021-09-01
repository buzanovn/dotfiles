# Default tilix fix for VTE
VTE_PROFILE_SH="$(find /etc/profile.d -name 'vte*.sh' | head -n1)"
_zsh_log_var VTE_PROFILE_SH
if ( [ $TILIX_ID ] || [ $VTE_VERSION ] ) && [[ -e $VTE_PROFILE_SH ]]; then
    source $VTE_PROFILE_SH
fi