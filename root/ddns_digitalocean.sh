# digital ocean variant made by zoltan at szasz dot me
#
# activated inside /etc/config/ddns by setting
#
# option update_script '/usr/lib/ddns/update_sample.sh'
#
# the script is parsed (not executed) inside send_update() function
# of /usr/lib/ddns/dynamic_dns_functions.sh
# so you can use all available functions and global variables inside this script
# already defined in dynamic_dns_updater.sh and dynamic_dns_functions.sh
#
# It make sence to define the update url ONLY inside this script
# because it's anyway unique to the update script
# otherwise it should work with the default scripts
#
# the code here is the copy of the default used inside send_update()
#
# tested with spdns.de
# inside url we need domain, username and password
[ -z "$domain" ]   && write_log 14 "Service section not configured correctly! Missing 'domain'"
[ -z "$username" ] && write_log 14 "Service section not configured correctly! Missing 'username'"
[ -z "$password" ] && write_log 14 "Service section not configured correctly! Missing 'password'"

IPV4_ADDR=$__IP
DOMAIN=$domain
TOKEN=$URL_PASS
RECORD=$URL_USER

DATA='{"data":"'${IPV4_ADDR}'"}'
URL="https://api.digitalocean.com/v2/domains/${DOMAIN}/records/${RECORD}"

write_log 7 "update request with following parameters: ipv4_addr=${IPV4_ADDR} digital_ocean_domain=${DOMAIN} digital_ocean_auth_token=${TOKEN} digital_ocean_record_id=${RECORD}"
write_log 7 "execute..."

wget \
  -O ${DATFILE} \
  --save-header \
  --no-check-certificate \
  --method="PUT" \
  --header="Content-Type: application/json" \
  --header="Authorization: Bearer ${TOKEN}" \
  --body-data=${DATA} "${URL}" 2>${ERRFILE}

write_log 7 "execution result:"$?
write_log 7 "DDNS Provider answered:\n$(cat $DATFILE)"

# analyse provider answers
grep -i -E "Status: 200 OK" $DATFILE >/dev/null 2>&1
return $?	
