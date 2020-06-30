# Default tilix fix for VTE
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

export ZSH_D=$HOME/.zsh.d
export EDITOR=vim
export ZSH_THEME="romkatv/powerlevel10k"
# Another variants, uncomment to ovveride top declaration
#export ZSH_THEME="https://github.com/caiogondim/bullet-train-oh-my-zsh-theme bullet-train"
#export ZSH_THEME=ys 
#export ZSH_THEME="https://github.com/denysdovhan/spaceship-zsh-theme spaceship"
#export ZSH_THEME=agnoster


function install_antigen_theme_parameters {
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
}

if [[ ! -e "${ZSH_D}/antigen/antigen.zsh" ]]; then
  echo "Antigen not found, installing it from git.io/antigen"
  mkdir -p "${ZSH_D}/antigen"
  curl -fsSL git.io/antigen > "${ZSH_D}/antigen/antigen.zsh"
fi
. "${ZSH_D}/antigen/antigen.zsh"

OS_TYPE=$(cat /etc/os-release | grep ID | head -n1 | cut -d= -f2)
antigen use oh-my-zsh
antigen theme ${ZSH_THEME}

antigen bundles <<EOBUNDLES
git
pip
zsh-users/zsh-completions
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
EOBUNDLES

if [[ $OS_TYPE = "ubuntu" ]]; then
    antigen bundle ubuntu
fi
antigen apply
setopt nocorrectall
install_antigen_theme_parameters
for zshf in $ZSH_D/*.zsh; do
    source $zshf
done
