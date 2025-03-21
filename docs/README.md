# Infra overview

## Physical facilities

### Node

| Hostname        | Global IP        | OS           | Private IP       | IPMI           | Alias                     | Memo                        |
| :-------------- | :--------------- | :----------- | :--------------- | :------------- | :------------------------ | :-------------------------- |
| [`gw`](./gw.md) | `130.158.42.241` | pfSense      | `172.16.255.254` |                |                           |                             |
| `kvm-serv`      |                  | CentOS 7     | `172.16.0.200`   | `172.16.0.210` |                           | KVM Host                    |
| `mail`          | `130.158.78.1`   | CentOS 7     | `172.16.0.1`     | `172.16.254.1` | `serv1`                   | Postfix, Dovecot, Mailman   |
| `node0`         | `130.158.42.5`   | Ubuntu 24.04 | `172.16.0.232`   | `172.16.0.211` | `mail-skylake`, `docker2` | DNS                         |
| `node1`         |                  | Ubuntu 24.04 | `172.16.0.230`   | `172.16.0.231` |                           | Web                         |

Global IPが固定的に割り当てられているのは`gw`のみ。
他のノードは`gw`上でGlobal IPを管理している。Private IPは全て固定的に割り当てている。
場所は全てCCSのCygnusと同じサーバールームのラックに存在。

### Switch

| Hostname | Private IP     | Location                        |
| `sw0`    | `172.16.255.0` | CCSサーバー室 ラックB 35番         |
| `sw1`    | `172.16.255.1` | SB1221 サーバー室 学情スイッチラック |

### UPS

| 接続先      | バッテリ交換日 | 備考                                |
| `kvm-serv` | 	2023/01/27  | バッテリ備品番号: M2210D000000059.000 |

