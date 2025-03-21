# `gw`

## 提供サービス

- dhcpd (pfSense)
- ルーティング (pfSense)
- ファイアウォール (pfSense)
- ノードへのNAT
- [Webコンソール](https://gw.lab.hpcs.cs.tsukuba.ac.jp)
  - 内部ネットワークからでないと繋がらないので注意

## 管理者設定

- admin
  - 基幹系パスワードで入れる
- LDAP
  - 共通LDAPでHPCS-ADMINがついているユーザーは入れる

## DNS 

- `node1.lab.hpcs.cs.tsukuba.ac.jp`

## DHCP

|:---------------|:--------------------------------|
| Lease range    | `172.16.100.0 - 172.16.101.255` |
| DNS	         | `172.16.0.230`, `1.1.1.1`       |
| Search domain	 | lab.hpcs.cs.tsukuba.ac.jp       |
| Gateway	     | `172.16.255.254`                |

##　その他設定

- `172.16.0.0/16` -> `0.0.0.0/0 (except 172.16.0.0/16)` はすべてNAT
- upstreamからの通信について，www, serv1(mail), dnsについては必要なportをforwarding
- gwがwwwなどのnodeに対する通信を受け取った際に応答するようにProxy ARPを設定
