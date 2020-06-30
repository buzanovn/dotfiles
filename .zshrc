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
  echo "$@" 1>&2; 
}

function download_antigen { 
  if [[ ! -e $ZSH_ANTIGEN_PATH ]]; then
    local antigen_url="git.io/antigen"
    echo "Antigen not found, installing it from git.io/antigen"
    mkdir -p $(dirname $ZSH_ANTIGEN_PATH)
    if [[ -n "$(command -v curl)" ]]; then 
      curl -fsSL $antigen_url > $ZSH_ANTIGEN_PATH
    elif [[ -n "$(command -v wget)" ]]; then 
      wget $antigen_url -qO $ZSH_ANTIGEN_PATH
    else
      echoerr "Neither curl nor wget were found, can not download antigen"
      exit 1
    fi
  fi
}

source $ZSH_ANTIGEN_PATH


antigen use oh-my-zsh
antigen theme ${ZSH_THEME}

antigen bundles <<EOBUNDLES
git
pip
zsh-users/zsh-completions
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
EOBUNDLES

case $DISTRNAME in 
  ubuntu) 
    antigen bundle ubuntu
    ;;
  *)
    ;;
esac
antigen apply

case "$ZSH_THEME" in 
    *powerlevel10k)
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
    # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    ;;
  *spaceship)
    export SPACESHIP_DOCKER_SHOW=false
    ;;
esac

for zshf in $ZSH_D/*.zsh; do
    source $zshf
done
