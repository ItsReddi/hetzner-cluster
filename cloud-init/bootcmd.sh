#!/bin/bash

sed -i '/- 2a01:4ff:ff00::add:1/c \                - 2001:4860:4860::8888' /etc/netplan/50-cloud-init.yaml
sed -i '/- 2a01:4ff:ff00::add:2/d' /etc/netplan/50-cloud-init.yaml
printf "network:\n  version: 2\n  ethernets:\n    eth0:\n      nameservers:\n        addresses:\n          - 8.8.8.8\n          - 2001:4860:4860::8888\n          - 8.8.4.4\n      dhcp4-overrides:\n        use-dns: false\n" > /etc/netplan/90-cloud-init.yaml
netplan apply

