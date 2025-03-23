# DNS

権威DNSはCoreDNS、フルリゾルバはKnot DNSを使用。

## 権威

ゾーン情報のマスターはAnsibleのファイルを参照すること。
外部向けドメインは`.hpcs.cs.tsukuba.ac.jp.`であり、内部向けは`.lab.hpcs.cs.tsukuba.ac.jp`になっている。内部向けは`172.16.0.0/16`からのみ応答。

### メモ

CoreDNSを選定したのはシンプルであり設定ファイルが理解しやすいこと、
k8sのコアコンポーネントなので継続的なメンテナンスが期待出来ることから。運用はsystemd

## フルリゾルバ

内部向けドメインを複雑なDNS設定なしに解決するためのリゾルバ。
基本的にシステムが使うべきではない。

```
modules.load('view')

net.listen('{{ net.internal.ip }}', 53, { kind = 'dns' })
net.listen('{{ net.internal.ip }}', 853, { kind = 'tls' })
net.listen('{{ net.internal.ip }}', 8443, { kind = 'doh2' })

internalDomains = policy.todnames({'hpcs.cs.tsukuba.ac.jp'})
policy.add(policy.suffix(policy.FLAGS({'NO_CACHE'}), internalDomains))
policy.add(policy.suffix(policy.STUB({'{{ authoritative_dns.internal_ip }}'}), internalDomains))

view:addr('172.16.0.0/16', policy.all(policy.PASS))
view:addr('0.0.0.0/0', policy.all(policy.DROP))

cache.size = 100 * MB
```

### メモ

どうしてもフルリゾルバはあった方が良さそうなので導入。
Unboundは設定が割と面倒くさいのでシンプルに再起動で運用出来るkresdを選択。
Knot resolverはチェコのNICが開発していて、そこそこ信頼出来る。

## stub resolver

`systemd-resolver`が利用可能な場合はフルリゾルバは不要である。
グローバルDNS設定では`1.1.1.1`を利用し、
Per-Link DNSを利用して`.hpcs.cs.tsukuba.ac.jp.`のsuffixを持つ場合だけ権威DNSを使わせる。

### `/etc/systemd/resolved.conf`


```conf
#  This file is managed by ansible

[Resolve]
# Some examples of DNS servers which may be used for DNS= and FallbackDNS=:
# Cloudflare: 1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
# Google:     8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.google
# Quad9:      9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
DNS=1.1.1.1 1.0.0.1
#FallbackDNS=
#Domains=
#DNSSEC=no
#DNSOverTLS=no
#MulticastDNS=no
#LLMNR=no
#Cache=no-negative
#CacheFromLocalhost=no
#DNSStubListener=yes
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no
#StaleRetentionSec=0
```

### `/etc/systemd/network/example.network`
```conf
[Match]
MACAddress={{ net.internal.mac }}

[Network]
Address={{ net.internal.ip }}/{{ net.internal.subnet_size }}
DNS=172.16.0.232
Domains=~.hpcs.cs.tsukuba.ac.jp

[Route]
Destination=0.0.0.0/0
Gateway=172.16.255.254
```
