# infra

研究室の基幹系サービスの IaaC モノレポ

## Node

| Hostname   | Global IP        | OS           | Private IP       | IPMI           | Alias                     | Memo                                    |
| :--------- | :--------------- | :----------- | :--------------- | :------------- | :------------------------ | :-------------------------------------- |
| `gw`       | `130.158.42.241` | pfSense      | `172.16.255.254` |                |                           |                                         |
| `kvm-serv` |                  | CentOS 7     | `172.16.0.200`   | `172.16.0.210` |                           | KVM Host                                |
| `auth`     |                  | CentOS 7     | `172.16.0.220`   |                |                           | LDAP, RADIUS, on `kvm-serv`             |
| `fs`       |                  | CentOS 7     | `172.16.0.223`   |                |                           | Samba, NFS                              |
| `work`     | `130.158.78.7`   | CentOS 7     | `172.16.0.11`    |                |                           | SSH Bastion, on `kvm-serv`              |
| `mail`     | `130.158.78.1`   | CentOS 7     | `172.16.0.1`     | `172.16.254.1` | `serv1`                   | Postfix, Dovecot, Mailman               |
| `node0`    | `130.158.42.5`   | Ubuntu 24.04 | `172.16.0.232`   | `172.16.0.211` | `mail-skylake`, `docker2` | DNS                                     |
| `node1`    |                  | Ubuntu 24.04 | `172.16.0.230`   | `172.16.0.231` |                           |                                         |
