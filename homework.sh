#!/usr/bin/env bash

FILE=output.txt
IMAGE=bootup.svg

echo .....Kernel start info >> $FILE
sudo systemd-analyze >> $FILE

echo .....Fathers and sons >> $FILE
pstree >> $FILE

echo .....Who was waiting for >> $FILE
systemd-analyze blame >> $FILE

echo .....Visualization >> $FILE
systemd-analyze plot > $IMAGE

echo .....Who was the slowest guy >> $FILE
systemd-analyze critical-chain >> $FILE

echo .....PATH >> $FILE
systemctl show-environment >> $FILE

echo .....Systemd services >> $FILE
ls /lib/systemd/system | wc -l

echo .....Our templates or services from installed apps >> $FILE
ls /etc/systemd/system | wc -l

echo .....Default variables from systemd >> $FILE
systemctl show sshd.service

echo .....Start stop status >> $FILE
sudo systemctl status cups >> $FILE
sudo systemctl stop cups
sudo systemctl status cups >> $FILE
sudo systemctl start cups
sudo systemctl status cups >> $FILE

echo .....Settings of the service >> $FILE
systemctl cat cups.service >> $FILE
systemctl show cups -p MemoryMax >> $FILE

echo .....Change RAM for service, additional generated file >> $FILE
sudo systemctl set-property cups MemoryMax=2G
systemctl show cups -p MemoryMax >> $FILE
systemctl cat cups.service >> $FILE

echo .....Restore initial params >> $FILE
sudo systemctl stop cups.service  # for preventing adding conf file
sudo rm -rf /etc/systemd/system.control/cups.service.d
sudo systemctl daemon-reload
sudo restart cups.service
sudo systemctl cat cups.service
sudo systemctl status cups.service

echo .....Runlevel >> $FILE
runlevel >> $FILE
systemctl get-default >> $FILE
systemctl list-units -t target | grep graphical >> $FILE
systemctl list-units -t target --all >> $FILE
systemctl cat basic.target >> $FILE
ls /sbin/{halt,poweroff,reboot,shutdown} >> $FILE
ls -l /sbin/{halt,poweroff,reboot,shutdown} >> $FILE

echo .....Units >> $FILE
ls -l /lib/systemd/system | wc -l >> $FILE
ls -l /run/systemd/system | wc -l >> $FILE
ls -l /etc/systemd/system | wc -l >> $FILE
ls -l /etc/systemd/system >> $FILE

echo .....Timers >> $FILE
systemctl list-timers >> $FILE
systemctl cat fstrim.timer >> $FILE
systemd-analyze calendar hourly >> $FILE
systemd-analyze calendar daily >> $FILE
systemd-analyze calendar weekly >> $FILE
systemd-analyze calendar monthly >> $FILE

echo .....Logs >> $FILE
sudo journalctl --list-boots >> $FILE
systemd-cgls >> $FILE
sudo journalctl --since=-5m >> $FILE
sudo journalctl --list-catalog >> $FILE
sudo journalctl --disk-usage >> $FILE


echo .....Systemd containers >> $FILE
machinectl list-images >> $FILE
machinectl status buster1 >> $FILE
systemctl status systemd-nspawn@buster1.service >> $FILE
sudo machinectl stop buster1
systemctl status systemd-nspawn@buster1.service >> $FILE

machinectl list-images >> $FILE
machinectl status jammy1 >> $FILE
systemctl status systemd-nspawn@jammy1.service >> $FILE
sudo machinectl stop jammy1
systemctl status systemd-nspawn@jammy1.service >> $FILE
