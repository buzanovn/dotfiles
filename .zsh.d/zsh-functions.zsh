#!/bin/zsh

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
        zsh)  source ~/.zshrc ;;
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
