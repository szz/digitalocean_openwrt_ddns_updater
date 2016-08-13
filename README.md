# digitalocean openwrt ddns updater
This script might be a useful for you if you use Digital Ocean as name server and you would update your OpenWRT based hosts with dynamic IP address.

## how to create a new sub domain
```
TOKEN='digital_ocean_auth_token'
IPV4_ADDR='ipv4_addr' 
DOMAIN='your.sub.domain.tld'

DATA='{"name":"'${DOMAIN}'","ip_address":"'$IPV4_ADDR'"}'

wget \
  -O - \
  --quiet \
  --save-header \
  --no-check-certificate \
  --method="POST" \
  --header="Content-Type: application/json" \
  --header="Authorization: Bearer ${TOKEN}" \
  --body-data=${DATA} "https://api.digitalocean.com/v2/domains"

```

## how to determine record id
```
TOKEN='digital_ocean_auth_token'
DOMAIN='your.sub.domain.tld'

wget \
  -O - \
  --quiet \
  --no-check-certificate \
  --method="GET" \
  --header="Content-Type: application/json" \
  --header="Authorization: Bearer ${TOKEN}" \
  "https://api.digitalocean.com/v2/domains/${DOMAIN}/records" | jq '' | grep -B 1 '"type": "A"'
  
```

## settings
* _DDNS Service provider [IPv4]_: --custom--
* _Custom update-script_: full path to updater script (eg: /root/ddns_digitalocean.sh)
* _Hostname/Domain_: your domain or sub domain
* _Username_: record id of your domain or sub domain
* _Password_: your Digital Ocean authentication token


## detailed info:
* [Digital Ocean registration (affilated with $10 gift)](https://m.do.co/c/15372e13c7aa)
* [OpenWRT ddns package](https://wiki.openwrt.org/doc/howto/ddns.client)
* [Digital Ocean API documentation](https://developers.digitalocean.com/documentation/v2/#list-all-domains)
