#!/bin/zsh

function http_download() {
  local url="$1"
  local dest="$2"
  if [[ -z $dest ]]; then
    dest=/dev/stdout
  fi
  local curl_binary="$(command -v curl)"
  local wget_binary="$(command -v wget)"
  if [[ -n $curl_binary ]]; then 
    $curl_binary -fsSL "$url" > $dest
  elif [[ -n $wget_binary ]]; then 
    $wget_binary -qO - "$url" > $dest
  else
    echoerr "Error: Neither curl nor wget were found, can not perform download"
    return 1
  fi
  ret=$?
  return "$ret"
}

function conf() {
    conf_path=~/.config
    case $1 in
    i3)      $EDITOR $conf_path/$1/config ;;
	bspwm)   $EDITOR $conf_path/$1/bspwmrc  ;;
	polybar) $EDITOR $conf_path/$1/config ;; 
	zsh)     $EDITOR ~/.zshrc ;;
	termite) $EDITOR $conf_path/$1/config ;;
	Xres)    $EDITOR ~/.Xresources ;;
	vim)     $EDITOR ~/.vimrc ;;	
	*)       echo "Provide one of the options" ;;
    esac
}

function reload() {
    case $1 in
        zsh)  exec zsh ;;
        Xres) xrdb ~/.Xresources ;;
		*)    echo "Provide one of the options" ;;
    esac
}

function e() {
	$EDITOR $1
}

function te() {
	touch $1
	e $1
}
