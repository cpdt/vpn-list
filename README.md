# VPN IP List Generator

Generates an IPv4 list from VPN sources. Based on [X4BNet's VPN list scripts](https://github.com/X4BNet/lists_vpn).

Current sources:
 - A custom ASN list
 - ProtonVPN's public IP list

## Usage

 1. Ensure `jq` and `perl` are installed - e.g. `apt install jq perl` on Ubuntu.
 2. Download [IP2Location™'s LITE IP-ASN Database](https://lite.ip2location.com/database-asn) and save it as `IP2LOCATION-LITE_ASN.CSV` in a working directory.
 3. Create an ASN.txt file in the same working directory and fill it with one ASN per line. [X4BNet's VPN ASN list](https://github.com/X4BNet/lists_vpn/blob/main/input/ASN.txt) might be a good start.
 4. Run `generate.sh` in this repo from the working directory. IP masks will be printed to stdout. Example:
    ```bash
    ./ip-list/generate.sh > ipv4.txt
    ```

## Using with ipset

You can use the output of this tool to create an [IP set](https://ipset.netfilter.org/) for a firewall. For example, if you already have a `hash:net` IP set called `vpns`:

```bash
ipset create vpns-new hash:net

while read p; do
    ipset add vpns-new "$p"
done < ./ipv4.txt

ipset swap vpns-new vpns
ipset destroy vpns-new

# if you have netfilter-persistent installed to persist ipsets across reboots
netfilter-persistent save
```
