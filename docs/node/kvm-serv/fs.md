# ファイルサーバ

[`kvm-serv`](./README.md)に存在。

## RAID6ディスクのマウント

`virt-manager`上でファイルサーバに RAID6 のディスクを直接割り当てる．
この KVM ホストマシンの場合`/dev/sda` が RAID6 のディスクになっている．
これをマウントして再起動すると `/dev/vdb` という名前になっているので，これを `/home` のマウント先にする．

```sh
parted /dev/vdb
(parted) mklabel gpt
(parted) mkpart primary ext4 0 -0
(parted) p
(parted) q
mkfs -t ext4 /dev/vdb1
```

```sh
mount -t ext4 /dev/vdb1 /home
```

### `/etc/fstab`

```fstab
/dev/vdb1 /home ext4 default 0 0
```

### `/etc/exports`

```exports
/home   172.16.0.0/16(sync,rw,no_root_squash)
```



```sh
yum install nfs-utils
systemctl enable rpcbind nfs-server
systemctl start rpcbind nfs-server
```

## Samba設定　

```sh
yum install -y samba samba-client samba-common
```

### `/etc/samba/smb.conf`

```conf
[global]
       dos charset = CP932
       unix charset = UTF-8

       workgroup = HPCS
       netbios name = fs
       server string = HPCS File Server (fs)

       passdb backend = ldapsam:ldap://172.16.0.220
       ldap suffix = dc=hpcs,dc=cs,dc=tsukuba,dc=ac,dc=jp
       ldap user suffix = ou=People,o=HPCS
       ldap group suffix = ou=Group,o=HPCS
       ldap admin dn = cn=Manager,dc=hpcs,dc=cs,dc=tsukuba,dc=ac,dc=jp
       ldap passwd sync = yes
       ldap ssl = no

       max log size = 100
       disable spoolss = yes
       load printers = no
       dns proxy = no
       case sensitive = no

       guest ok = yes
       guest account = hpcs-nobody
       map to guest = Bad User

       wins proxy = yes
       wins support = yes
       domain master = yes
       preferred master = yes
       local master = yes
       os level = 64
       domain logons = no
       logon path =
       logon home =

[homes]
       comment = Home Directories
       read only = no
       browseable = no

[proceedings]
       comment = Conference Proceedings
       path = /home/proceedings
       read only = no
       guest ok = yes
       directory mask = 0777
       force directory mode = 0775
       force create mode = 0774
       force user = hpcs-nobody
       force group = HPCS

[share]
       comment = Share File Space
       path = /home/samba/share
       read only = no
       guest ok = yes
       directory mask = 0777
       force directory mode = 0775
       force create mode = 0774
       force user = hpcs-nobody
       force group = HPC
```

```sh
smbpasswd -W
systemctl enable --now smb
```
