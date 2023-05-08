#!/bin/bash

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
  --hcloud-token)
    TOKEN="$2"
    shift
    shift
  ;;
  --hcloud-firewall-id)
    FIREWALL_ID="$2"
    shift
    shift
  ;;
  *)
    shift
  ;;
esac
done

sed -i 's/[#]*PermitRootLogin yes/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sed -i 's/[#]*PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
sed -i 's/[#]*PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/[#]*PasswordAuthentication no/PasswordAuthentication no/g' /etc/ssh/sshd_config

systemctl restart sshd

wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
chmod +x jq-linux64
mv jq-linux64 /usr/local/bin/jq

curl -o /usr/local/bin/add-to-cloud-fw.sh https://raw.githubusercontent.com/itsreddi/hetzner-cluster/main/cloud-init/api/add-to-cloud-fw.sh
chmod +x /usr/local/bin/add-to-cloud-fw.sh

/usr/local/bin/add-to-cloud-fw.sh --hcloud-token ${TOKEN} --hcloud-firewall-id ${FIREWALL_ID}
