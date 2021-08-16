# Default tilix fix for VTE
if ( [ $TILIX_ID ] || [ $VTE_VERSION ] ) && [[ -f /etc/profile.d/vte.sh ]]; then
    source /etc/profile.d/vte.sh
fi

function echoerr { 
  tput setaf 1; 
  echo "$@" 1>&2;
}

export DISTRNAME=$(cat /etc/os-release | grep ID | head -n1 | cut -d= -f2)
export EDITOR=vim

#############################
# ZSH.D Configuration block #
#############################
export ZSH_D="$HOME/.zsh.d"
export ZSH_ANTIGEN_PATH="$ZSH_D/antigen/antigen.zsh"

#### Theme configuration #####
export ZSH_THEME=ys 
# Another variants, uncomment to ovveride top declaration
#export ZSH_THEME="https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train"
#export ZSH_THEME="romkatv/powerlevel10k"
#export ZSH_THEME="https://github.com/denysdovhan/spaceship-zsh-theme spaceship"
#export ZSH_THEME=agnoster

#################################
# Loading configuration block ###
#################################
APPLY_ANTIGEN=true
autoload -U compinit && compinit
for zshf in $ZSH_D/*.zsh; do
  source $zshf; 
done