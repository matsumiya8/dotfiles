#!/bin/bash

pacman -Qe paru >/dev/null || {
	cd $HOME
	sudo pacman -S --noconfirm --needed base-devel git
	git clone https://aur.archlinux.org/paru-bin.git
	cd paru && makepkg -si
	cd .. && rm -rf paru
}

[ ! -f $HOME/packages.txt ] && wget https://raw.githubusercontent.com/matsumiya8/dotfiles/refs/heads/main/install/packages.txt -O $HOME/packages.txt
PKGLIST=$(cat $HOME/packages.txt |  paste -sd ' ')

paru -S --skipreview --nosudoloop --norebuild --noconfirm --noprovides --needed $PKGLIST

chezmoi init https://github.com/matsumiya8/dotfiles.git
chezmoi apply
systemctl --user enable --now pipewire-pulse.service
sudo chsh -s /usr/bin/zsh
sudo systemctl enable ly.service
