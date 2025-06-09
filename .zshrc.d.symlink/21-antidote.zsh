#!/bin/zsh

# Oh My ZSH related variables
# speeding up the load
export DISABLE_UNTRACKED_FILES_DIRTY="true"
export DISABLE_AUTO_UPDATE="true"

export ANTIDOTE_D="/home/$USER/.antidote.d"

export ANTIDOTE_GIT_DIR="/home/$USER/.cache/antidote-distro"

export ANTIDOTE_PLUGINS_CACHE_DIR="/home/$USER/.cache/antidote-plugins-cache"
export ANTIDOTE_PREV_PLUGINS_TXT="$ANTIDOTE_PLUGINS_CACHE_DIR/prev_zsh_plugins.txt"
export ANTIDOTE_PLUGINS_TXT="$ANTIDOTE_PLUGINS_CACHE_DIR/zsh_plugins.txt"
export ANTIDOTE_PLUGINS_ZSH="$ANTIDOTE_PLUGINS_CACHE_DIR/zsh_plugins.zsh"
export ANTIDOTE_ADDITIONAL_SOURCES="$ANTIDOTE_PLUGINS_CACHE_DIR/additional_sources.zsh"

for d in "${ANTIDOTE_D}" "${ANTIDOTE_PLUGINS_CACHE_DIR}"; do
  mkdir -p "$d"
done

function download_antidote { 
  if [[ ! -e $ANTIDOTE_GIT_DIR ]]; then
    echoerr "Antidote not found, installing it"
    mkdir -p "$(dirname "$ANTIDOTE_GIT_DIR")"
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_GIT_DIR"
    if [[ "$?" -ne 0 ]] ; then
      echoerr "Installing antidote failed"
      return 1
    fi
    return 0
  fi
}

########################################################
# PLUGINS DEFINITION
########################################################
SOURCES=()

PLUGINS=()
PLUGINS+=("rupa/z")
PLUGINS+=("romkatv/zsh-defer")
PLUGINS+=("greymd/docker-zsh-completion")

PLUGINS+=("getantidote/use-omz")
PLUGINS+=("ohmyzsh/ohmyzsh path:lib")
PLUGINS+=("ohmyzsh/ohmyzsh path:plugins/git")
PLUGINS+=("ohmyzsh/ohmyzsh path:plugins/pip")
PLUGINS+=("ohmyzsh/ohmyzsh path:plugins/cp")
PLUGINS+=("ohmyzsh/ohmyzsh path:plugins/sudo")
PLUGINS+=("ohmyzsh/ohmyzsh path:plugins/ssh")
PLUGINS+=("ohmyzsh/ohmyzsh path:plugins/ubuntu")

if [[ -n "$ZSH_THEME_PLUGIN" ]]; then
  PLUGINS+=("$ZSH_THEME_PLUGIN")
  theme_settings_dir="$ANTIDOTE_D/themes/$ZSH_THEME_PLUGIN"
  if [[ -d "$theme_settings_dir" ]]; then
    while IFS= read -r -d '' file; do
      SOURCES+=("$file")
    done < <(find "$theme_settings_dir" -maxdepth 1 -name '*.zsh' -type f -print0)
  fi
elif [[ -n "$ZSH_NATIVE_THEME" ]]; then
  PLUGINS+=("ohmyzsh/ohmyzsh path:themes/${ZSH_NATIVE_THEME}.zsh-theme")
fi

PLUGINS+=("zsh-users/zsh-completions")
PLUGINS+=("zsh-users/zsh-syntax-highlighting")
PLUGINS+=("zsh-users/zsh-autosuggestions")
PLUGINS+=("zsh-users/zsh-history-substring-search")

########################################################
# MAIN BLOCK
########################################################

# Download antidote if it does not exist
if ! download_antidote; then 
  echoerr "No antidote found, exiting"
  return  
fi

# Overwrite plugins.txt with content of PLUGINS array
if [[ ! -f "$ANTIDOTE_PREV_PLUGINS_TXT" ]]; then
  touch "$ANTIDOTE_PREV_PLUGINS_TXT"
fi
ANTIDOTE_PREV_PLUGINS_TXT_HASH=$(sha256sum < "$ANTIDOTE_PREV_PLUGINS_TXT" | awk '{print $1}')

if [[ -f "$ANTIDOTE_PLUGINS_TXT" ]]; then
  touch "$ANTIDOTE_PLUGINS_TXT"
fi
printf "%s\n" "${PLUGINS[@]}" > "$ANTIDOTE_PLUGINS_TXT"
ANTIDOTE_PLUGINS_TXT_HASH=$(sha256sum < "$ANTIDOTE_PLUGINS_TXT" | awk '{print $1}')

# Autoload antidote as a function
fpath+=("$ANTIDOTE_GIT_DIR")
autoload -Uz antidote
if ! typeset -f antidote >/dev/null; then
  echoerr "Antidote not found. Please install it first."
fi

# Get bundles from txt file and create a zsh bundles file
# only when zsh bundles file is older then txt bundles file
if [[ "$ANTIDOTE_PREV_PLUGINS_TXT_HASH" != "$ANTIDOTE_PLUGINS_TXT_HASH" ]]; then
  antidote bundle < "$ANTIDOTE_PLUGINS_TXT" >| "$ANTIDOTE_PLUGINS_ZSH"
  cat "$ANTIDOTE_PLUGINS_TXT" > "$ANTIDOTE_PREV_PLUGINS_TXT"
fi

# Load bundles from zsh file
if [[ -f "$ANTIDOTE_PLUGINS_ZSH" ]]; then
  source "$ANTIDOTE_PLUGINS_ZSH"
fi

# Overwrite additional_sources.zsh with content of SOURCES array
if [[ -f "$ANTIDOTE_ADDITIONAL_SOURCES" ]]; then 
  rm "$ANTIDOTE_ADDITIONAL_SOURCES"
fi
if [[ ${#SOURCES} -gt 0 ]]; then
  [[ -f "$ANTIDOTE_ADDITIONAL_SOURCES" ]] || touch "$ANTIDOTE_ADDITIONAL_SOURCES"
  printf "source %s\n" "${SOURCES[@]}" > "$ANTIDOTE_ADDITIONAL_SOURCES"
  # Load additional sources
  source "$ANTIDOTE_ADDITIONAL_SOURCES"
fi