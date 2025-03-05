#!/bin/bash

pacman -Qe paru-bin >/dev/null || {
	cd $HOME
	sudo pacman -S --noconfirm --needed base-devel git
	git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin && makepkg -si
	cd .. && rm -rf paru-bin
}

[ -f $HOME/packages.txt ] && curl -o $HOME/packages.txt https://raw.githubusercontent.com/matsumiya8/dotfiles/refs/heads/main/install/packages.txt
PKGLIST=$(cat $HOME/packages.txt |  paste -sd ' ')

paru -S --skipreview --nosudoloop --norebuild --noconfirm --noprovides --needed $PKGLIST

chezmoi init https://github.com/matsumiya8/dotfiles.git
chezmoi apply
systemctl --user enable --now pipewire-pulse.service
sudo chsh -s /usr/bin/zsh
sudo systemctl enable ly.service
