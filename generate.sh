#!/bin/bash

asnListFile=./ASN.txt
asnTableFile=./IP2LOCATION-LITE-ASN.CSV

# Fetch ProtonVPN IPs
echo "Fetching ProtonVPN IPs" >&2
curl https://api.protonmail.ch/vpn/logicals | jq '.LogicalServers[].Servers[].ExitIP' -r > /tmp/iplist_unprocessed.txt

# Process ASN.txt and output asn-preprocess.txt (IPv4 only)
cat "$asnListFile" | grep -v '^#' | awk '{print $1}' | grep '^AS' | while read asn; do
  echo "Processing $asn" >&2
  awk -F "\"*,\"*" '{if($4 == '${asn:2}') print $3}' "$asnTableFile" >> /tmp/iplist_unprocessed.txt
done

# Sort and process lists
sort -n /tmp/iplist_unprocessed.txt > /tmp/iplist_ipv4.txt
perl ./cleanup.pl /tmp/iplist_ipv4.txt

rm /tmp/iplist_unprocessed.txt
rm /tmp/iplist_ipv4.txt
