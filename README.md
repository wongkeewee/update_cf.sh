# Update Cloudflare DNS Script

This bash scripts updates the dynamic public IP of your server to Cloudflare DNS.

This script compares the current public IP address against the Cloudflare DNS IP address and update the Cloudflare DNS entry with the current IP address.

## Prerequisites

This script requires the jq JSON Processor package to parse the json output from Cloudflare API

```
RHEL/CentOS
$ sudo yum install jq

DEBIAN
$ sudo apt-get install jq
```

## Configuring

Define the parameters at the top of the script.

### Zone ID

Define the Zone ID Parameter.
The value can be found on the Overview Page.

### API Token

Generate an API Token for this script in Cloudflare.
Grant the edit permission to the DNS Zone for your domain.

### Host

Define the Fully Qualified Domain Name of your host in the domain.

### Record ID

Get the record ID of your host FQDN using the API Token generated above and the Zone ID.

```
$ curl -X GET "https://api.cloudflare.com/client/v4/zones/<zone id>/dns_records?name=<host> \
-H "Authorization: Bearer <API Token>" \
-H "Content-Type: application/json" | jq -r '.result[].id'
```

## Deployment

After configuring the script, change the permission of the script to allow execution and define a cron job to periodically poll and update the Cloudflare DNS entry.


```
$ chmod +x /path/to/update_cf.sh

$ crontab -e
*/30 * * * * /path/to/update_cf.sh
```

