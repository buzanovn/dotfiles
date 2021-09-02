#!/bin/bash

if [ "$EUID" -ne 0 ];then 
  echo "Please run as root"
  exit
fi

PACKAGES="zsh ncdu mc vim git gdebi tilix nmap tmux"

APT_UPDATE="apt update -yqq"
APT_INSTALL="apt install -yqq"

SOURCES_LIST_D="/etc/apt/sources.list.d"

UBUNTU_CODENAME="$(grep UBUNTU_CODENAME /etc/os-release | cut -d= -f2)"

add_repo_list() {
	local rep="$1"
	local rep_name="$2"
	echo "$rep" > "$SOURCES_LIST_D/$rep_name.list"
}

http_download() {
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
    echo "Error: Neither curl nor wget were found, can not perform download"
    return 1
  fi
  ret=$?
  return "$ret"
}

add_pubkey() {
	local key_url="$1"
	wget -qO - "$key_url" | apt-key add -
}

path_to_gpg() {
	local gpg_name="$1"
	echo "/etc/apt/trusted.gpg.d/${gpg_name}.gpg"
}

add_gpgkey() {
	local gpg_key_url="$1"
	local gpg_key_name="$2"
	local gpg_key_path="$(path_to_gpg $gpg_key_name)"
	http_download "$gpg_key_url" | gpg --dearmor | dd of="$gpg_key_path"
	echo $gpg_key_path
}

install_deb() {
	local deb_url="$1"
	local deb="/tmp/$(date +'+%d%m%Y%H%M%S').deb"
	http_download "$deb_url" "$deb"
	$(command -v gdebi) -n $deb
	rm -f $deb
}

add_vscodium_repo() {
	add_gpgkey 'https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg' vscodium
	add_repo_list 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' vscodium
	PACKAGES="$PACKAGES codium"
}

add_chrome_repo() {
	add_pubkey 'https://dl.google.com/linux/linux_signing_key.pub'
	add_repo_list 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' google-chrome
	PACKAGES="$PACKAGES google-chrome-stable"
}

add_spotify_repo() {
	add_pubkey 'https://download.spotify.com/debian/pubkey_0D811D58.gpg'
	add_repo_list 'deb http://repository.spotify.com stable non-free' spotify
	PACKAGES="$PACKAGES spotify-client"
}

add_docker_repo() {
	install_packages apt-transport-https ca-certificates gnupg lsb-release
	gpg_key_path=$(add_gpgkey 'https://download.docker.com/linux/ubuntu/gpg' docker)
	add_repo_list "deb [arch=amd64 signed-by=$gpg_key_path] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} stable" docker
	PACKAGES="$PACKAGES docker-ce docker-ce-cli containerd.io"
}

install_discord() {
	echo "Installing Discord"
	install_deb 'https://discordapp.com/api/download?platform=linux&format=deb'
}

install_teamviewer() {
	echo "Installing Teamviewer"
	install_deb 'https://download.teamviewer.com/download/linux/teamviewer_amd64.deb'
}

afterinstall_docker() {
	if [[ ! $(groups $USER | cut -d: -f2 | grep -o -e docker) ]]; then
		usermod -aG docker $USER
		echo "Added user to docker group, should logout or use newgrp"
	fi
}

install_docker_compose() {
	get_latest_compose_release() {
		url="https://api.github.com/repos/docker/compose/releases/latest"
		echo "$(wget -qO- $url | grep -Po '"tag_name": "\K.*?(?=")')"
	}

	local url="https://github.com/docker/compose/releases/download/$(get_latest_compose_release)/docker-compose-$(uname -s)-$(uname -m)"
	local binary="/usr/local/bin/docker-compose"
	http_download $url > $binary
	chmod +x $binary
	ln -s $binary /usr/bin/docker-compose
}

additional_install_hooks() {
	install_discord
	install_teamviewer
	afterinstall_docker
	install_docker_compose
}

install_packages() {
	$APT_UPDATE
	echo "Installing $@"
	$APT_INSTALL $@
}

add_vscodium_repo
add_chrome_repo
add_spotify_repo
add_docker_repo

install_packages "$PACKAGES"
additional_install_hooks