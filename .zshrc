# Default tilix fix for VTE
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi


export ZSH_D="$HOME/.zsh.d"
export ZSH_ANTIGEN_PATH="$ZSH_D/antigen/antigen.zsh"
export DISTRNAME=$(cat /etc/os-release | grep ID | head -n1 | cut -d= -f2)
export EDITOR=vim
export ZSH_THEME="romkatv/powerlevel10k"
# Another variants, uncomment to ovveride top declaration
#export ZSH_THEME="https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train"
#export ZSH_THEME=ys 
#export ZSH_THEME="https://github.com/denysdovhan/spaceship-zsh-theme spaceship"
#export ZSH_THEME=agnoster

function echoerr { 
  tput setaf 1; 
  echo "$@"
}

APPLY_ANTIGEN=true

for zshf in $ZSH_D/*.zsh; do source $zshf; done