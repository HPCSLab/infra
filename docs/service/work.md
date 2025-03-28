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

## 移行先

`node0`のdockerサーバで動かす予定。[hpcslab/bastion](https://github.com/hpcslab/bastion)にコードが存在。
ホストの認証系を汚染しないためにdockerを使っているが、`macvlan`だとホストのIPへの疎通が出来ず`host`だと同じポートでlisten出来ない。
簡単にするために`10022`ポートでlistenしてgwでNAPTすることにする。

## Wiki

Pukiwikiは既にPHP最新バージョンへの追従が出来なくなりつつあり、
運用上コストがかかっており将来的には[Outline](https://github.com/outline/outline)もしくは[GROWI](https://growi.org/ja/)への移行を検討。
現状では優先度は低い。
