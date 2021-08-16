# Default tilix fix for VTE
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

function echoerr { 
  tput setaf 1; 
  echo "$@"
}

export DISTRNAME=$(cat /etc/os-release | grep ID | head -n1 | cut -d= -f2)
export EDITOR=vim

#############################
# ZSH.D Configuration block #
#############################
export ZSH_D="$HOME/.zsh.d"
export ZSH_ANTIGEN_PATH="$ZSH_D/antigen/antigen.zsh"
function load_zsh_d() {
  for zshf in $ZSH_D/*.zsh; do 
    echo "Sourcing $zshf"
    source $zshf; 
  done
}

#### Theme configuration #####

export ZSH_THEME="romkatv/powerlevel10k"
# Another variants, uncomment to ovveride top declaration
#export ZSH_THEME="https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train"
#export ZSH_THEME=ys 
#export ZSH_THEME="https://github.com/denysdovhan/spaceship-zsh-theme spaceship"
#export ZSH_THEME=agnoster

#################################
# Loading configuration block ###
#################################
APPLY_ANTIGEN=true
load_zsh_d