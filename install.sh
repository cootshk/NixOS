#!/usr/bin/env bash

# Check if running as root. If not root, script will exit
if [[ $EUID -ne 0 ]]; then
	echo "This script should be executed as root! Exiting..."
	exit 1
fi



scriptdir=$(realpath $(dirname $0))
currentUser=$(logname)

# Delete dirs that conflict with home-manager
rm -f  /home/$currentUser/.mozilla/firefox/profiles.ini
rm -rf /home/$currentUser/.gtkrc-*
rm -rf /home/$currentUser/.config/gtk-*
rm -rf /home/$currentUser/.config/cava
rm -rf /home/$currentUser/*.old
rm -rf /home/$currentUser/.*.old
sync # make sure that ~/.gtkrc-2.0.old is deleted

# replace user variable in flake.nix with $USER
sed -i -e 's/username = \".*\"/username = \"'$currentUser'\"/' $scriptdir/flake.nix

# rm -f $scriptdir/hosts/Default/hardware-configuration.nix &>/dev/null
#if ! cp $(find /etc/nixos -iname 'hardware-configuration.nix') $scriptdir/hosts/Default/hardware-configuration.nix; then
#	# Generate new config
#	clear
# 	nix-shell --command "echo GENERATING CONFIG! | figlet -cklno | lolcat -F 0.3 -p 2.5 -S 300"
# 	nixos-generate-config --show-hardware-config >$scriptdir/hosts/Default/hardware-configuration.nix
# fi

nix-shell --command "sudo -u $currentUser git -C $scriptdir add *"
rm -f /home/$currentUser/.gtkrc-2.0
rm -f /home/$currentUser/.gtkrc-2.0.old
sync
clear
nix-shell --command "echo BUILDING! | figlet -cklnoW | lolcat -F 0.3 -p 2.5 -S 300"
NIXPKGS_ALLOW_UNFREE=1 sudo -u $currentUser nix-shell --command "NIXPKGS_ALLOW_UNFREE=1 sudo nixos-rebuild switch --flake $scriptdir#nixos --show-trace --impure $@" # && rm -rf $backupdir"
echo "$backupdir"
