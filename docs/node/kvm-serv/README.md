# kvm-serv

qemuによって色々なサービスを運用する。入居中のゲストは以下の通り。

| Hostname            | Global IP        | OS           | Private IP       | Memo                        |
| :------------------ | :--------------- | :----------- | :--------------- | :-------------------------- |
| [`auth`](./auth.md) | `130.158.42.3`   | CentOS 7     | `172.16.0.220`   | LDAP, RADIUS, on `kvm-serv` |
| [`fs`](./fs.md)     |                  | CentOS 7     | `172.16.0.223`   | Samba, NFS                  |


`virsh`でマシンの一覧は見えるが`virsh console`は使用不能。
ゲストへはXサーバを起動してKVM仮想マシンマネージャからアクセスするか、SSH経由でアクセスする。

## ブリッジホスト設定（Pukiwikiのログより転記）

```sh
$ yum install bridge-utils bind-utils
$ nmcli connection delete enp4s0f0
$ nmcli connection add type bridge autoconnect yes con-name br0 ifname br0
$ nmcli connection modify br0 bridge.stp no
$ nmcli connection add type bridge-slave autoconnect yes con-name enp4s0f0 ifname enp4s0f0 master br0
$ nmcli connection modify br0 ipv4.method manual ipv4.addresses "172.16.0.200/16" ipv4.gateway 172.16.255.254 ipv4.dns 172.16.0.1 ipv4.dns-search "lab.hpcs.cs.tsukuba.ac.jp hpcs.cs.tsukuba.ac.jp"
$ nmcli connection up br0
$ ip addr
$ ping 8.8.8.8
$ ping www.google.com
$ brctl show
bridge name    bridge id        STP enabled    interfaces
br0        8000.0cc47a68945a    no        enp4s0f0
virbr0        8000.5254007f9b2e    yes        virbr0-nic
```

virbr0 は KVM がデフォルトで設定しているものなので消して良い．

```sh
$ virsh net-destroy default
$ virsh net-autostart default --disable
$ brctl show
bridge name    bridge id        STP enabled    interfaces
br0        8000.0cc47a68945a    no        enp4s0f0
```

## GUI設定

GNOME Desktopがインストール済み。XForwardingも有効化されている。

## RAID管理ツール（Pukiwikiより転記）

```sh
$ ln -sf /usr/lib64/libcrypto.so.1.0.1e /lib64/libcrypto.so.4
$ ln -sf /usr/lib64/libssl.so.1.0.1e /lib64/libssl.so.4
$ yum install xterm -y
$ tar xvf MSM_linux_x64_installer-15.11.00-13.tar.gz
$ cd disk
$ ./install.csh -s -ru snmp      #-s: standalone,  -ru snmp: without snmp
$ service vivaldiframeworkd start  #systemctlで起動すると管理ツールから認識されない
```

メール通知設定
MSMを起動し、「Tools -> Monitor Configure Alerts」を開く
- Alert Settings
  - Severity Level = Critical でもEmailを送るよう設定
- Mail Server
  - Sender email address: kvm-serv-raid@hpcs.cs.tsukuba.ac.jp
  - SMTP Server: mail.hpcs.cs.tsukuba.ac.jp
  - User name: kvm-serv-raid
  - Password: mailmanのやつ
- Email
  - 受け取りアドレスに hpcs-admin@hpcs.cs.tsukuba.ac.jp を設定する。デフォルトの root@localhost は消す。設定後送信テストを行う。
