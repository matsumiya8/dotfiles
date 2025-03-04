#!/bin/bash

pacman -Qe paru || {
	cd $HOME
	sudo pacman -S --needed base-devel
	git clone https://aur.archlinux.org/paru.git
	cd paru && makepkg -si
	cd .. && rm -rf paru
}

PKGLIST=$(curl -fsSL https://raw.githubusercontent.com/matsumiya8/dotfiles/refs/heads/main/install/packages.txt | paste -sd ' ')

paru -S --skipreview --nosudoloop $PKGLIST

chezmoi init https://github.com/matsumiya8/dotfiles.git
chezmoi apply
chsh -s /usr/bin/zsh
systemctl --user enable --now pipewire-pulse.service
sudo systemctl enable ly.service
