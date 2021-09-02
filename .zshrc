#!/bin/zsh
export DISTRNAME=$(cat /etc/os-release | grep ID | head -n1 | cut -d= -f2)
export EDITOR=vim

#############################
# ZSH.D Configuration block #
#############################
export ZSH_D="/home/$USER/.zshrc.d"

#### Theme configuration #####
export ZSH_THEME=ys
# export ZSH_THEME=agnoster/agnoster-zsh-theme
# export ZSH_THEME=caiogondim/bullet-train-oh-my-zsh-theme
# export ZSH_THEME=romkatv/powerlevel10k
# export ZSH_THEME=denysdovhan/spaceship-zsh-theme

#################################
# Loading configuration block ###
#################################
autoload -U compinit && compinit

ZSH_D_SCRIPTS=$(find "$ZSH_D" -name '*.zsh' -type f | sort)
while IFS= read -r line; do
  source $line
done <<<"$ZSH_D_SCRIPTS"