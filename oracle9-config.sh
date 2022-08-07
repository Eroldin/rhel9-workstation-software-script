#!/bin/bash

if [ "$EUID" -eq 0 ]
  then echo "Please do not run as root"
  exit
fi

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd $__dir

sudo flatpak remote-add -v --if-not-exists fedora oci+https://registry.fedoraproject.org
sudo flatpak remote-add -v --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "---"
sudo dnf install -y --nogpgcheck https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm https://mirrors.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-$(rpm -E %rhel).noarch.rpm zram-generator gnome-extensions-app gnome-tweaks
sudo cp -r  ./zram/usr/lib/systemd/* /usr/lib/systemd/
sudo dnf makecache
sudo dnf install -y ./icons/*.rpm ./pop-shell/*.rpm ./steam-prep/*.rpm ./office/*.rpm gnome-extensions-app gnome-tweaks dconf-editor hyphen-en neofetch

# Change the locale setting to that which is applicable to you.
cat <<-EOF | sudo tee /etc/locale.conf >/dev/null
	LANG="en_US.UTF-8"
	LANGUAGE=
	LC_TIME="en_GB.UTF-8"
	LC_CTYPE="en_US.utf-8"
	LC_NUMERIC="nl_NL.utf-8"
	LC_COLLATE="en_US.utf-8"
	LC_MONETARY="nl_NL.utf-8"
	LC_MESSAGES="en_US.utf-8"
	LC_PAPER="nl_NL.utf-8"
	LC_NAME="nl_NL.utf-8"
	LC_ADDRESS="nl_NL.utf-8"
	LC_TELEPHONE="nl_NL.utf-8"
	LC_MEASUREMENT="nl_NL.utf-8"
	LC_IDENTIFICATION="nl_NL.utf-8"
	LC_ALL=
EOF

sudo -v
flatpak install -y --noninteractive com.google.Chrome com.valvesoftware.Steam com.github.Matoking.protontricks net.davidotek.pupgui2 com.valvesoftware.Steam.CompatibilityTool.Proton com.valvesoftware.Steam.Utility.steamtinkerlaunch
sudo -v
flatpak install -y --noninteractive librewolf org.videolan.VLC/x86_64/stable io.mpv.Mpv/x86_64/stable onlyoffice org.gtk.Gtk3theme.Adwaita-dark

echo ""; echo "Preparing for updates...  it will automatically reboot."
sleep 3
sudo pkcon update --only-download
sudo pkcon offline-trigger
sudo systemctl reboot
