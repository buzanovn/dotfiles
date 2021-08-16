#!/bin/bash

add_vscodium_repo() {
	wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
	echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | tee --append /etc/apt/sources.list.d/vscodium.list
}

add_chrome_repo() {
	wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
	echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
}

install_packages() {
	apt update
	apt install $@
}

PACKAGES="zsh google-chrome-stable codium ncdu mc"

add_vscodium_repo
add_chrome_repo
install_packages "$PACKAGES"
