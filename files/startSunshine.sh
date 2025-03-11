sudo systemctl restart avahi-daemon
systemctl --user restart sunshine
sudo setcap cap_sys_admin+p $(readlink -f $(which sunshine))
sudo systemctl restart xow
