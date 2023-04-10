#!/bin/zsh

export ZSH_ANTIBODY_DIR="$ZSH_D/antibody"
export ZSH_ANTIBODY_PATH="$ZSH_ANTIBODY_DIR/antibody"
DISTR_ID="$(grep -E '^ID=' /etc/os-release | cut -d= -f2)"

function download_antibody { 
  if [[ ! -e $ZSH_ANTIBODY_PATH ]]; then
    local url="git.io/antibody"
    echoerr "Error: Antibody not found, installing it from git.io/antigen"
    mkdir -p $(dirname $ZSH_ANTIBODY_PATH)
    http_download $url | sh -s - -b $ZSH_ANTIBODY_DIR
    if [[ "$?" -ne 0 ]] ; then
      echoerr "Error: installing antigen failed"
      return 1
    fi
    chmod +x $ZSH_ANTIBODY_PATH
    return 0
  fi
}

function update_antibody {
  if [[ -e $ZSH_ANTIBODY_PATH ]]; then 
  	mv $ZSH_ANTIBODY_PATH $ZSH_ANTIBODY_PATH.bak
  fi
  return download_antibody
}

if ! download_antibody; then 
  echoerr "No antibody found, exiting"
  exit 
fi

PATH=$PATH:$(dirname $ZSH_ANTIBODY_PATH)

function find_theme() {
  # Try find theme in ohmyzsh folder
  local omz_themes_dir="$(antibody path ohmyzsh/ohmyzsh)/themes"
  local omz_themes="$(ls $omz_themes_dir)"
  _zsh_log $omz_themes
  if grep $ZSH_THEME -q <<<"$omz_themes"; then
    echo "ohmyzsh/ohmyzsh path:themes/${ZSH_THEME}.zsh-theme"
  else
    echo "$ZSH_THEME"
  fi
}

function format_omz_plugin() {
  echo "ohmyzsh/ohmyzsh path:plugins/${1}"
}

function add_bundle_to_list() {
  for arg in $@; do
    BUNDLES_LIST=$(printf "${BUNDLES_LIST}\n$arg")
  done
}

function add_omz_plugin_to_list() {
  for arg in $@; do
    add_bundle_to_list "$(format_omz_plugin $arg)"
  done
}

BUNDLES_LIST=$(cat <<EOBUNDLES
zsh-users/zsh-completions
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-history-substring-search
zsh-users/zsh-autosuggestions
ohmyzsh/ohmyzsh path:lib
EOBUNDLES
)

OH_MY_ZSH_PLUGINS=$(cat <<EOBUNDLES
git
pip
docker
docker-compose
cp
sudo
EOBUNDLES
)

while IFS= read -r line; do
  add_omz_plugin_to_list $line
done <<<"$OH_MY_ZSH_PLUGINS"

case "$DISTR_ID" in
  ubuntu|elementary)
    add_omz_plugin_to_list ubuntu
    ;;
esac

_zsh_log "$BUNDLES_LIST"

source <(antibody init)
antibody bundle <<<"$BUNDLES_LIST"
antibody bundle "$(find_theme)"

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


