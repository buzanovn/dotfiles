#!/bin/zsh

function toan {
	cd $AN_PROJECTS
}

function topy {
	cd $PY_PROJECTS
}

function activate() { 
    export VIRTUAL_ENV_DISABLE_PROMPT='1' 
    source ~/.venvs/$1/bin/activate 
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

function wine_launch() {
	c_disk=$HOME/.wine/drive_c
	case $1 in
		wow) wine "$c_disk/Program Files (x86)/WoWCircle 3.3.5a/WoW.exe" -opengl
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

function jbls() {
	ps_output=$(sudo docker ps | grep jetbrains | cut -c1-12)
	ip=$(sudo docker inspect $ps_output | grep "IPAddress" | tail -1 | cut -d'"' -f4)
	address="http://$ip:8000"
	echo $address
	echo "Address was copied to clipboard"
	echo $address | xclip -selection c
}


h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi
