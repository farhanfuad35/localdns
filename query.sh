#!/bin/bash

# File containing the list of top domains
DOMAIN_LIST="top_domains_bd.txt"

# Output file for dnsmasq custom hosts
CUSTOM_HOSTS="/etc/dnsmasq.d/custom_hosts"

# DNS server to query
DNS_SERVER="8.8.8.8"  # You can replace this with your preferred DNS server

# Clear the custom hosts file
echo "" > $CUSTOM_HOSTS

# Query each domain and add to the custom hosts file
while IFS= read -r domain; do
    attempts=0
    while [ $attempts -lt 3 ]; do
        ip=$(dig @$DNS_SERVER +short $domain | head -n 1)
        if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            echo "address=/$domain/$ip"
            echo "address=/$domain/$ip" >> $CUSTOM_HOSTS
            sleep 1
            break
        fi
        
        attempts=$((attempts + 1))
        DNS_SERVER="1.1.1.1"
        echo "Failed, trying again [$attempts], Server: $DNS_SERVER"
    done
done < $DOMAIN_LIST

systemctl restart dnsmasq
