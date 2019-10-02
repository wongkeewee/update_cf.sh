#!/bin/sh

# Define Cloudflare Parameters
zone_id=<cf zone>
token=<cf API token>
host=<cf dns host>
record_id=<cf record>	

# Get WAN IP
current_ip=`/usr/bin/curl ifconfig.me`

# Get DNS IP
record_ip=`/usr/bin/curl -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?type=A&name=$host" \
-H "Authorization: Bearer $token" \
-H "Content-Type: application/json" | /usr/bin/jq -r '.result[].content'`

# Update Cloudflare DNS Entry if different
if [ "$current_ip" != "$record_ip" ]; then
/usr/bin/curl -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" \
-H "Authorization: Bearer $token" \
-H "Content-Type: application/json" \
--data '{"type":"A","name":"'$host'","content":"'$current_ip'","ttl":1}'

/bin/logger "Cloudflare IP updated to $current_ip"

else

/bin/logger "Cloudflare IP not updated"
fi