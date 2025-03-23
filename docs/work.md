# work

踏み台サーバ

## LDAP有効化

```sh
yum update -y
yum install setuptool nscd nss-pam-ldapd pam_ldap openldap-clients
authconfig-tui
```

以下で設定する。多分TUI経由になる。

```
server: ldap://auth.lab.hpcs.cs.tsukuba.ac.jp/
base dn: dc=hpcs,dc=cs,dc=tsukuba,dc=ac,dc=jp
```

## NFSマウント

公開鍵はNFSから取得するので以下のパッケージをインストール。

```sh
yum install nfs-utils
systemctl start rpcbind 
systemctl enable rpcbind
```

```fstab
fs.lab.hpcs.cs.tsukuba.ac.jp:/home /home nfs rw,rsize=8192,wsize=8192,hard,intr,bg 0 0
```

```sh
mount -a
```
