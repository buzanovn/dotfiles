#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PACKAGES="zsh ncdu mc vim git gdebi"

APT_UPDATE="apt update -yqq"
APT_INSTALL="apt install -yqq"

SOURCES_LIST_D="/etc/apt/sources.list.d"

add_repo_list() {
	local rep="$1"
	local rep_name="$2"
	echo "$rep" > "$SOURCES_LIST_D/$rep_name.list"
}

add_pubkey() {
	local key_url="$1"
	wget -qO - "$key_url" | apt-key add -
}

add_gpgkey() {
	local gpg_key_url="$1"
	local gpg_key_name="$2"
	wget -qO - "$gpg_key_url" | gpg --dearmor | dd of="/etc/apt/trusted.gpg.d/${gpg_key_name}.gpg"
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

install_discord() {
	echo "Installing discord"
	local deb=/tmp/discord.deb
	wget -q -O $deb 'https://discordapp.com/api/download?platform=linux&format=deb'
	$(command -v gdebi) -n $deb
	rm -f $deb
}

additional_install_hooks() {
	install_discord
}

install_packages() {
	$APT_UPDATE
	echo "Installing $@"
	$APT_INSTALL $@
	additional_install_hooks
}

add_vscodium_repo
add_chrome_repo
add_spotify_repo

install_packages "$PACKAGES"
