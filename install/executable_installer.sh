#!/bin/bash

set -euo pipefail
pacman -Q yay-bin >/dev/null || {
	sudo pacman -S --needed git base-devel
	git clone https://aur.archlinux.org/yay-bin.git
	cd yay-bin && makepkg -si && cd .. && rm -rf yay-bin
}

sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
test -e $HOME/packages.txt || curl -o $HOME/packages.txt https://raw.githubusercontent.com/matsumiya8/dotfiles/refs/heads/main/install/packages.txt
PKGLIST=$(cat $HOME/packages.txt |  paste -sd ' ')

yay -Syu --nosudoloop --noconfirm --noprovides --needed $PKGLIST

sudo tee "/usr/share/X11/xkb/symbols/custom" > /dev/null <<'EOF'
default
xkb_symbols "qwerty" {

    include "us(alt-intl)"
    replace key <AC11> { [ dead_acute, quotedbl, apostrophe, quotedbl ] };
    replace key <CAPS> {
        type="ALPHABETIC",
        repeat=No,
        symbols[Group1] = [ Caps_Lock, Caps_Lock ],
        actions[Group1] = [ LockMods(modifiers=Lock),
                            LockMods(mods=Shift+Lock, affect=unlock) ]
    };

    modifier_map Shift { Shift_Lock };

};
EOF

sudo tee "/etc/security/limits.d/50-descriptors-fix.conf" > /dev/null <<'EOF'
*            hard    nofile  524288
*            soft    nofile  65535
EOF

sudo tee "/etc/pam.d/greetd" > /dev/null <<'EOF'
#%PAM-1.0

auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so
auth       optional     pam_kwallet5.so
account    include      system-local-login
session    include      system-local-login

session    required     pam_systemd.so
session    optional     pam_gnome_keyring.so auto_start
session    optional     pam_kwallet5.so      auto_start
EOF

echo ":executo:M::MZ::${HOME}/.config/scripts/exec.sh:" | sudo tee "/etc/binfmt.d/wine.conf" > /dev/null

xdg-user-dirs-update
mkdir -p ~/.cache/wallpapers/
chezmoi init --apply https://github.com/matsumiya8/dotfiles.git
chsh -s /usr/bin/zsh
sudo chsh -s /usr/bin/zsh
systemctl --user enable --now pipewire-pulse.service
sudo systemctl enable --now fstrim.timer bluetooth.service greetd
sudo systemctl restart systemd-binfmt.service
