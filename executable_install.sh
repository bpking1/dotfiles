#!/bin/bash

# 还有groups,虚拟机配置，input设备手柄
# Nvidia GPU only
# linux-headers: Headers and scripts for building modules for the Linux kernel
# nvidia-dkms: NVIDIA drivers - module sources
# qt5-wayland: Provides APIs for Wayland
# qt5ct: Qt5 Configuration Utility
# libva: Video Acceleration (VA) API for Linux
# libva-nvidia-driver-git [AUR]: VA-API implementation that uses NVDEC as a backend (git version)

# swaylock-effects [AUR]: A fancier screen locker for Wayland.
# wlogout [AUR]: Logout menu for wayland
# swappy: A Wayland native snapshot editing tool
# thunar: Modern, fast and easy-to-use file manager for Xfce
# pavucontrol: PulseAudio Volume Control
# brightnessctl: Lightweight brightness control tool
# bluez: Daemons for the bluetooth protocol stack
# bluez-utils: Development and debugging utilities for the bluetooth protocol stack
# blueman: GTK+ Bluetooth Manager
# network-manager-applet: Applet for managing network connection
# gvfs: Virtual filesystem implementation for GIO
# thunar-archive-plugin: Adds archive operations to the Thunar file context menus
# file-roller: Create and modify archives
# lxappearance: Feature-rich GTK+ theme switcher of the LXDE Desktop
# xfce4-settings: Xfce's Configuration System
# sddm-sugar-candy-git [AUR]: Sugar Candy is the sweetest login theme available for the SDDM display manager.

# set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

# clear the screen
clear

# set some expectations for the user
echo -e "$CNT - You are about to execute a script that would attempt to setup Hyprland.
Please note that Hyprland is still in Beta."
sleep 1

# attempt to discover if this is a VM or not
echo -e "$CNT - Checking for Physical or VM..."
ISVM=$(hostnamectl | grep Chassis)
echo -e "Using $ISVM"
if [[ $ISVM == *"vm"* ]]; then
	echo -e "$CWR - Please note that VMs are not fully supported and if you try to run this on
    a Virtual Machine there is a high chance this will fail."
	sleep 1
fi

# let the user know that we will use sudo
echo -e "$CNT - This script will run some commands that require sudo. You will be prompted to enter your password.
If you are worried about entering your password then you may want to review the content of the script."
sleep 1

# give the user an option to exit out
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to continue with the install (y,n) ' CONTINST
if [[ $CONTINST == "Y" || $CONTINST == "y" ]]; then
	echo -e "$CNT - Setup starting..."
else
	echo -e "$CNT - This script would now exit, no changes were made to your system."
	exit
fi

# add AUR
if grep -q "archlinuxcn" /etc/pacman.conf; then
	echo -e "$CNT - archlinuxcn already exists in pacman.conf. Skipping..."
else
	echo -e "$CNT - add archlinuxcn..."
	printf "[archlinuxcn] \nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch" | sudo tee -a /etc/pacman.conf
	sudo pacman -Syu --noconfirm && sudo pacman -S --noconfirm archlinuxcn-keyring
fi

echo -e "$CNT - install yay"
sudo pacman -S --noconfirm yay

# Ask if the use has an NVIDIA GPU
read -rep $'[\e[1;33mACTION\e[0m] - Do you have an Nvidia GPU? (y,n) ' ISNVIDIA
if [[ $ISNVIDIA == "Y" || $ISNVIDIA == "y" ]]; then
	echo -e "$CWR - Please note that support for Nvidia GPUs is limited.
    This script would attempt to set things up the best way it can.
    If you do end up with a black screen after trying to login then the GPU is likely the issue."

	ISNVIDIA=true
else
	ISNVIDIA=false
fi

### Disable wifi powersave mode ###
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to disable WiFi powersave? (y,n) ' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
	LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
	echo -e "$CNT - The following file has been created $LOC."
	echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC &>>$INSTLOG
	echo -e "\n"
	echo -e "$CNT - Restarting NetworkManager service..."
	sleep 1
	sudo systemctl restart NetworkManager &>>$INSTLOG
	sleep 3
fi

#### Check for package manager ####
ISYAY=/sbin/yay
if [ -f "$ISYAY" ]; then
	echo -e "$COK - yay was located, moving on."
else
	echo -e "$CWR - Yay was NOT located.. yay is (still) required"
	read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install yay (y,n) ' INSTYAY
	if [[ $INSTYAY == "Y" || $INSTYAY == "y" ]]; then
		git clone https://aur.archlinux.org/yay.git &>>$INSTLOG
		cd yay
		makepkg -si --noconfirm &>>../$INSTLOG
		cd ..
	else
		echo -e "$CER - Yay is (still) required for this script, now exiting"
		exit
	fi
	# update the yay database
	echo -e "$CNT - Updating the yay database..."
	yay -Suy --noconfirm &>>$INSTLOG
fi

# function that will test for a package and if not found it will attempt to install it
install() {
	# First lets see if the package is there
	if yay -Q $1 &>>/dev/null; then
		echo -e "$COK - $1 is already installed."
	else
		# no package found so installing
		echo -e "$CNT - Now installing $1 ..."
		yay -S --noconfirm $1 &>>$INSTLOG
		# test to make sure package installed
		if yay -Q $1 &>>/dev/null; then
			echo -e "\e[1A\e[K$COK - $1 was installed."
		else
			# if this is hit then a package is missing, exit to review log
			echo -e "\e[1A\e[K$CER - $1 install had failed, please check the install.log"
			exit
		fi
	fi
}

# 安装软件的函数
install_software() {
	# 软件列表
	local software_list=("$@")

	# 默认情况下，所有软件都被选中
	declare -a selected_software=("${software_list[@]}")

	# 显示软件列表
	echo "select software to install: "
	for i in "${!software_list[@]}"; do
		echo "$i: ${software_list[$i]}"
	done

	# 等待用户输入
	read -p "input number to not install,install all(a),install none(n): " input

	# 如果用户输入了软件编号，则取消这些软件的安装
	if [[ ! -z "$input" ]]; then
		# 如果用户输入了all，则安装所有软件
		if [[ "$input" == "a" ]]; then
			selected_software=("${software_list[@]}")
		# 如果用户输入了none，则取消所有软件的安装
		elif [[ "$input" == "n" ]]; then
			selected_software=()
		# 否则，取消用户选择的软件的安装
		else
			selected_software=("${software_list[@]}")
			for i in $input; do
				if [[ "$i" =~ ^[0-9]+$ ]] && [[ $i -lt ${#software_list[@]} ]]; then
					unset 'selected_software[$i]'
				fi
			done
		fi
	fi
	# 安装或卸载软件
	if [[ ${#selected_software[@]} -eq 0 ]]; then
		echo "install none"
	else
		for software in "${selected_software[@]}"; do
			install $software
		done
	fi
}
# 安装软件
base_software_list=(
	intel-ucode # 微码 # amd: amd-ucode
	fish        #bash
	exa         # ls
	neovim      #
	bat         # cat
	fd          # find
	duf         # df
	broot       # tree
	ripgrep     # grep
	ncdu        # du     #ncdu --exclude /mnt
	procs       # ps
	dog         # dig
	gping       # ping
	fzf         # everything
	jq          #
	# tldr        # man
	cheat-bin # better than tldr
	docker
	docker-buildx
	docker-compose
	lazydocker
	git
	lazygit
	gitui # lazygit 替代
	forgit
	# ranger # cli 文件浏览器
	yazi
	neofetch
	htop  # top
	aria2 # download
	atuin # shell history
	tssh  # ssh
	rclone
	#alist # docker 安装吧
	syncthing
	cronie     # crontab
	starship   # cli prompt
	z.lua      #  快速跳转文件夹
	tmux       # screen
	ctop       # docker top
	downgrade  # 包降级
	progress   # 查看 cli进度
	p7zip      # 7z
	unarchiver # rar zip
	openssh
	unzip
	ntfs-3g # mount ntfs盘,手动mount吧
	# fonts,emoji
	adobe-source-han-serif-cn-fonts
	noto-fonts-cjk
	noto-fonts-emoji
	noto-fonts-extra
	ttf-firacode-nerd
	ttf-lxgw-wenkai-screen # luoxiaguwu or wenquanyi

	# bluetooth
	bluez
	bluez-utils

)

de_list=(
	# input method
	# fcitx5-im
	fcitx5
	fcitx5-configtool
	fcitx5-gtk
	fcitx5-qt
	fcitx5-chinese-addons
	fcitx5-pinyin-zhwiki
	fcitx5-pinyin-moegirl
	# fcitx5-pinyin-sougou # failed

	kitty
	sddm             #sddm-git
	sddm-sugar-candy # sddm theme
	apple-cursor     # cursor theme
	mpv
	pavucontrol
	mpd
	mpc        #管理mpd
	mpdris2-rs # 将mpd输出到mpris

)

de_list_extra=(

	flatpak # flatpak install xx
	ark     # kde ark can be used to browse, extract, create, and modify archives
	pot-translation
	aur/zotero-beta-bin # book reader
	krdc                # kde rdp client,need install freerdp
	freerdp
	ksystemlog # kde systemlog viewer
	google-chrome-stable
	gtk4   # chrome wayland cjk input
	upower # for chrome 好像是检测电源的，跟省电模式有关?
	samba  # mount
	go-musicfox-git
	obsidian
	sunshine # moonlight server
	# moonlight, parsec
	obs-studio # kooha 也行
	telegram
	mpv-handler
	revda-git # 直播 douyu依赖nodejs
	visual-studio-code-bin
	dbeaver # sqlbrowser
	qemu
	# devpod # appimage , dev container local
	rider # dotnet dev
	dotnet-sdk-bin
	aspnet-runtime-bin
	go
	rust
	nodejs
	flutter
	# v2raya, clash
	# 快捷搜索，翻译
	koodo-reader # reader
	# TaleBook     # calibre book docker
	QtScrcpy # android to pc
	sniffnet # network
	barrier  # 开源键鼠共享
	# localsend  # kdeconnect
	waydroid     # xdroid ,android container
	asciinema    # 终端录制工具
	virt-manager # qemu kvm 虚拟机管理
	waylyrics    # wayland 桌面歌词
	yt-dl        # video download
	ventoy-bin   # install system
	pomatez      # pomato clock todo
	neovide
	# yuzu         # ns cemulater
	# pipewire etc.. # 由archinstall装了
	# xone-dongle-firmware # xbox 手柄无线
	# xow-git  # xbox
)

#cutefish

amd_list=(mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon libva-mesa-driver lib32-libva-mesa-driver mesa-vdpau lib32-mesa-vdpau)

intel_list=(mesa lib32-mesa vulkan-intel lib32-vulkan-intel intel-media-driver intel-hybrid-codec-driver)

hyprland_list=(
	hyprland
	# hyprland-nvidia
	# surface need change scale
	# hypr.conf
	#monitor=,preferred,auto,2

	# kde-wallet
	xdg-desktop-portal-hyprland-git
	qt5-wayland      # qt6 hypr会自动装
	pamixer          # voice controll
	polkit-kde-agent # agent
	mako             # 系统通知
	networkmanager
	cava-git # cross-platform audio visualizer 非git的有bug
	waybar-cava
	rofi-lbonn-wayland-git # 应用启动，粘贴板
	grimblast-git          # 截图
	swappy                 # 编辑截图，图片
	wl-clipboard           # 粘贴版，结合cliphist保持历史记录，rofi搜索
	cliphist
	xorg-xlsclients # 查看应用是否是 xwayland运行
	nemo            # file explorer
	imv             # 图片查看
	# swww            # 壁纸
	variety #自动下壁纸
	wpaperd # 壁纸
	# mpvpaper  # video wallpaper,have bug in nvidia hyprland
	swaylock-effects #锁屏
)

### Install all of the above pacakges ####
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install the packages? (y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
	# Setup Nvidia if it was selected
	if [[ "$ISNVIDIA" == true ]]; then
		echo -e "$CNT - Nvidia setup stage, this may take a while..."
		for SOFTWR in linux-headers nvidia-dkms nvidia-settings lib32-nvidia-utils nvidia-vaapi-driver-git qt5ct libva libva-nvidia-driver-git; do
			install $SOFTWR
		done

		# 视频加速
		printf "NVD_BACKEND=direct \nLIBVA_DRIVER_NAME=nvidia" | sudo tee -a /etc/environment

		# update config
		sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/& nvidia_drm.modeset=1 /' /etc/default/grub
		sudo grub-mkconfig -o /boot/grub/grub.cfg

		sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
		sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
		echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf &>>$INSTLOG
	fi

	## Stage 1 - main components
	echo -e "$CNT - Stage 1 - Installing main components, this may take a while..."
	install_software "${base_software_list[@]}"

	## Stage 2 - de software, input method
	echo -e "$CNT - Stage 2 - install de software, this may take a while..."
	install_software "${de_list[@]}"
	# fcitx5 env
	echo -e "QT_IM_MODULE=fcitx\nXMODIFIERS=@im=fcitx\nSDL_IM_MODULE=fcitx\nGLFW_IM_MODULE=ibus" | sudo tee /etc/environment

	# 是否安装hyprland, (y,n)
	read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install hyprland? (y,n) ' INST_HYPR
	if [[ $INST_HYPR == "Y" || $INST_HYPR == "y" ]]; then
		echo -e "$CNT - Stage 3 - Installing hyprland, this may take a while..."
		install_software "${hyprland_list[@]}"
		# sddm auto login config
		sudo mkdir -p /etc/sddm.conf.d
		echo -e "[Autologin]\nUser=hj\nSession=hyprland.desktop" | sudo tee -a /etc/sddm.conf.d/autologin.conf

		WLDIR=/usr/share/wayland-sessions
		if [ -d "$WLDIR" ]; then
			echo -e "$COK - $WLDIR found"
		else
			echo -e "$CWR - $WLDIR NOT found, creating..."
			sudo mkdir $WLDIR
		fi

		# stage the .desktop file
		echo -e "[Desktop Entry]\nName=Hyprland\nComment=An intelligent dynamic tiling Wayland compositor\nExec=Hyprland\nType=Application" | sudo tee /usr/share/wayland-sessions/hyprland.desktop
		if [[ "$ISNVIDIA" == true ]]; then
			# setup nvidia startup file
			sudo sed -i 's/Exec=Hyprland/Exec=\/home\/'$USER'\/.start-hypr-nvidia/' /usr/share/wayland-sessions/hyprland.desktop
		else
			# setup non nvidia startup file
			sudo sed -i 's/Exec=Hyprland/Exec=\/home\/'$USER'\/.start-hypr-amd/' /usr/share/wayland-sessions/hyprland.desktop
		fi
	fi

	# 是否安装intel显卡驱动，(y,n)
	read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install the intel graphics driver? (y,n) ' INST_INTEL
	if [[ $INST_INTEL == "Y" || $INST_INTEL == "y" ]]; then
		echo -e "$CNT - Stage 4 - Installing intel graphics driver, this may take a while..."
		install_software "${intel_list[@]}"
	fi

	## Start the bluetooth service
	#echo -e "$CNT - Starting the Bluetooth Service..."
	#sudo systemctl enable --now bluetooth.service &>>$INSTLOG
	#sleep 2

	# Enable the sddm login manager service
	echo -e "$CNT - Enabling the SDDM Service..."
	sudo systemctl enable sddm &>>$INSTLOG
	sleep 2

	# Clean out other portals
	echo -e "$CNT - Cleaning out conflicting xdg portals..."
	yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk &>>$INSTLOG
fi

#	# setup the first look and feel as dark
#	xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
#	xfconf-query -c xsettings -p /Net/IconThemeName -s "Adwaita-dark"
#	gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
#	gsettings set org.gnome.desktop.interface icon-theme "Adwaita-dark"
#	cp -f ~/.config/HyprV/backgrounds/v3-background-dark.jpg /usr/share/sddm/themes/sdt/wallpaper.jpg
#fi
#
### Script is done ###
echo -e "$CNT - Script had completed!"
if [[ "$ISNVIDIA" == true ]]; then
	echo -e "$CAT - Since we attempted to setup Nvidia the script will now end and you should reboot.
    type 'reboot' at the prompt and hit Enter when ready."
	exit
fi

read -rep $'[\e[1;33mACTION\e[0m] - Would you like to start Hyprland now? (y,n) ' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
	exec sudo systemctl start sddm &>>$INSTLOG
else
	exit
fi
