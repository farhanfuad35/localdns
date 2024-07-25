### Quickly set up a local DNS server and populate with top ~100 websites in Bangladesh cached in seconds. Website list collected from [Semrush](https://www.semrush.com/trending-websites/bd/all).
You can add a cron job to run periodically and update any expired record. For example, execute `crontab -e` and insert the line below to run the script every 6 hours
```
0 */6 * * * <path-to-query.sh>
```

The goal of this project is to provide a decentralized DNS server in case of a nationwide DNS server shutdown as we have seen in recent times. With these locally hosted public DNS servers, it is expected that at least some important websites hosted inside the country can be accessed even if the ISPs shutdown their DNS servers. However, it is worth mentioning that this is an assumption made from previous experience and may not be true depending on the nature and the way future bans are implemented.

_On a relevant note, remembering all the people who lost their lives fighting for the right of the people in 2024 quota movement in Bangladesh. May their soul find eternal peace and may the friends and family they left behind have the courage to live on through their darkest days and find justice._

## Prerequisites
- Public IP with port 53 accessible.
- `dnsmasq`/`BIND` properly configured

## Troubleshoot
- If you find _port 53 is already in use error_, it's likely that `systemd-resolved` is running on that port. Use the following commands to find the process id and kill it. Then try starting `dnsmasq` again.
```
ss -lp "sport = :domain"
sudo kill -9 <pid>
sudo systemctl start dnsmasq
```
- Set your preferred DNS server in `/etc/dnsmasq.conf` file by setting the `server=` attribute.
- To enable log, add these lines in `/etc/dnsmasq.conf`:
```
log-queries
log-facility=/var/log/dnsmasq.log
```
- If you find that the hostnames are being resolved to their respective IPv6 address and failing to connect for some reason (ie. your network doesn't support IPv6),
 edit `/etc/gai.conf` and uncomment the following line to prioritize IPv4 over IPv6 while name resolution
```
#precedence ::ffff:0:0/96 100
```
- If you cannot make DNS queries from external network, make sure dnsmasq is configured properly. Set the following attribute in `/etc/dnsmasq.conf`
```
interface=<interface-your-query-is-coming-from>
```
Alternatively, you can also set this to listen from everything
```
listen-address=0.0.0.0
```
