#!/bin/zsh
export DISTRNAME=$(cat /etc/os-release | grep ID | head -n1 | cut -d= -f2)
export EDITOR=vim

#############################
# ZSH.D Configuration block #
#############################
export ZSH_D="/home/$USER/.zshrc.d"
export ZSH_ANTIBODY_DIR="$ZSH_D/antibody"
export ZSH_ANTIBODY_PATH="$ZSH_ANTIBODY_DIR/antibody"

#### Theme configuration #####
#export ZSH_THEME=agnoster/agnoster-zsh-theme
# Another variants, uncomment to ovveride top declaration
#export ZSH_THEME=caiogondim/bullet-train-oh-my-zsh-theme
#export ZSH_THEME=romkatv/powerlevel10k
export ZSH_THEME=denysdovhan/spaceship-zsh-theme

#################################
# Loading configuration block ###
#################################
APPLY_ANTIGEN=true
autoload -U compinit && compinit

for zshf in $ZSH_D/*.zsh; do
  source $zshf; 
done