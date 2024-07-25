## Quickly host a local DNS server and populate with top 100 websites in Bangladesh cached in seconds. Websites list collected from [Semrush](https://www.semrush.com/trending-websites/bd/all).

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
