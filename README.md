# TSDNS
Size optimised docker container via [alpine](https://hub.docker.com/_/alpine/) base-image.

[![](https://images.microbadger.com/badges/version/phaldan/tsdns:3.0.13.6.svg)](https://microbadger.com/images/phaldan/tsdns:3.0.13.6) [![](https://images.microbadger.com/badges/image/phaldan/tsdns.svg)](https://microbadger.com/images/phaldan/tsdns) ![](https://img.shields.io/docker/stars/phaldan/tsdns.svg) ![](https://img.shields.io/docker/pulls/phaldan/tsdns.svg) ![](https://img.shields.io/docker/automated/phaldan/tsdns.svg)

* `3.0.13.6`, `3.0.13`, `3.0`. `3`, `latest` ([Dockerfile](https://github.com/phaldan/docker-tsdns/blob/d6c4728213e81c3e15b466606e1f224f4ef6fc64/Dockerfile))
&nbsp;

# Run container

```
$  docker run -d --name tsdns -v ${PWD}/tsdns_settings.ini:/tsdns/tsdns_settings.ini -p 41144:41144 phaldan/tsdns
```
&nbsp;

# Reload `tsdns_settings.ini`
```
$ docker kill -s SIGUSR1 tsdns
```
&nbsp;

# What is TSDNS
TSDNS (TeamSpeak Domain Name System) allows to resolve a domain to the ip and port of your TeamSpeak 3 server. This can be achieved by adding a SVR-Record to the DNS of your domain ([How-to](https://support.teamspeakusa.com/index.php?/Knowledgebase/Article/View/293/0/does-teamspeak-3-support-dns-srv-records)). 
For example your TeamSpeak 3 server is running under `12.13.14.15:10000`. You could extend the DNS of your domain `example.com` with the following DNS record and can now connect with your TeamSpeak 3 client to your TeamSpeak 3 server by using `example.com` (instead of ip and port): 

```
_ts3._udp.example.com. 86400 IN SRV 0 5 10000 12.13.14.15.
```
&nbsp;
For a single domain you can use TSDNS without a TSDNS server, but for multiple domains it is easier to manage your domains with a dedicated TSDNS server. In this case you only need to extend the DNS of your domain with the following DNS record (TSDNS and TS3 server runs on same machine) and configure the domain resolve in the `tsdns_settings.ini`:

```
 _tsdns._tcp. example.com. 86400 IN SRV 0 5 41144 12.13.14.15.
```
&nbsp;

# Example of `tsdns_settings.ini`

```ini
# Example: The TSDNS server runs on on a box reachable as both as
# "teamspeak.com" and as "teamspeak-systems.de"
# So we might configure:
public.teamspeak.com=12.13.14.15:10000
test.teamspeak.com=12.13.14.15:12000
private.teamspeak.com=12.13.14.15:14000
voice.teamspeak.com=NORESPONSE
*.teamspeak-systems.de=1.2.3.4:15000
*=12.13.14.15:$PORT

# This way, now clients can connect to "test.teamspeak.com" to reach the test
# server, but if they still have the old "teamspeak.com:12000" in their
# bookmarks, it will also work thanks to the "*=12.13.14.15:$PORT" line, which
# acts as a backwards compatibility mechanism in this case, for everybody not
# using the new TSDNS names to connect.
```