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

NODE_IPS=( $(curl -H 'Accept: application/json' -H "Authorization: Bearer ${TOKEN}" 'https://api.hetzner.cloud/v1/servers?per_page=50' | jq -r '.servers[].public_net.ipv4.ip') )

NODE_IPS_JSON=""
for IP in "${NODE_IPS[@]}"; do
	NODE_IPS_JSON+=",\"${IP}/32\""
done
NODE_IPS_JSON=$(echo $NODE_IPS_JSON | cut -c2-)
#curl -v -X POST -H "Content-Type: application/json" -d '{"rules":[{"description":"Allow internal tcp","direction":"in","port":"any","protocol":"tcp","source_ips":['${NODE_IPS_JSON}']}]}' 'http://httpbin.org/post'
curl -X POST -H "Authorization: Bearer ${TOKEN}" -H "Content-Type: application/json" -d '{"rules":[{"description":"Allow internal tcp","direction":"in","port":"any","protocol":"tcp","source_ips":['${NODE_IPS_JSON}']},{"description":"Allow internal udp","direction":"in","port":"any","protocol":"udp","source_ips":['${NODE_IPS_JSON}']}]}' "https://api.hetzner.cloud/v1/firewalls/${FIREWALL_ID}/actions/set_rules"
