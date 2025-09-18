#!/usr/bin/env bash

echo -e "\e[31;43m Setting Up the user groups \e[0m"
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER

echo -e "\e[31;43m Checking groups \e[0m"
groups

echo -e "\e[31;43m Write kernel module \e[0m"
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee -a /etc/udev/rules.d/99-input.rules

echo -e "\e[31;43m Reload Udev \e[0m"
sudo udevadm control --reload-rules && sudo udevadm trigger

echo -e "\e[31;43m Confirmation \e[0m"
ls -l /dev/uinput

echo -e "\e[31;43m Ensure module load \e[0m"
sudo modprobe uinput
