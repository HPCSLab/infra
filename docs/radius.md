[auth](./auth.md)に存在

# 802.1x 認証のセットアップ

## AP 情報

| Name                         | IP         |Location | Web console                         |Firmware  | Note   |
|:-----------------------------|:-----------|:--------|:------------------------------------|:---------|:-------|
|wap4.lab.hpcs.cs.tsukuba.ac.jp|172.16.1.104|SB1124/25|http://wap4.lab.hpcs.cs.tsukuba.ac.jp|1.2.7     |        |
|wap5.lab.hpcs.cs.tsukuba.ac.jp|172.16.1.105|SB1121/22|http://wap5.lab.hpcs.cs.tsukuba.ac.jp|1.2.7     |        |
|wap6.lab.hpcs.cs.tsukuba.ac.jp|172.16.1.106|         |http://wap6.lab.hpcs.cs.tsukuba.ac.jp|1.2.7 beta| unused |

セットアップには，上記にブラウザからログイン．
ログイン情報は

- ユーザ名: admin
- パスワード: 基幹系のそれ

接続方法は WPA-EAP で WPA2 + PEAP (MS-CHAPv2) による通信，AESによる暗号化，
[ここ](https://www.fmworld.net/biz/fmv/product/hard/network/manual/security/manual/chap100010.html)を参照
AP の制限により認証が MS-CHAPv2 に固定，samba へ登録されている必要がある．

## RADIUS のセットアップ

gw だと従来の MAC アドレス認証との共存が面倒だったので，serv1 に設定．
標準的な設定方法は [これ]("http://blog.tsunokawa.net/entry/2015/10/23/153943") にしたがって進める．

PEAP 設定は [ここ]("http://uncho.clarus.jp/2012/04/%E8%AA%8D%E8%A8%BC%E6%96%B9%E5%BC%8Fpeap%E3%82%92%E4%BD%BF%E7%94%A8%E3%81%97%E3%81%9F%E7%84%A1%E7%B7%9Alan%E7%92%B0%E5%A2%83%E6%A7%8B%E7%AF%89/" rel="nofollow") を参照．

```sh
yum -y install freeradius freeradius-utils freeradius-ldap
```

以下は全て追記か，修正．
削除する行はないので，注意．


```
 $ vim /etc/raddb/dictionary
 VALUE Auth-Type LDAP 5
```



```
 $ vim /etc/raddb/users
 DEFAULT Auth-Type := EAP
                 Fall-Through = 1
```



```
 $ vim /etc/raddb/mods-available/ldap
 ldap {
   server = "127.0.0.1"
   base_dn ="ou=People,o=HPCS,dc=hpcs,dc=cs,dc=tsukuba,dc=ac,dc=jp"
   user {
     filter = "(uid=%{%{Stripped-User-Name}:-%{User-Name}})"
   }
 
   update {
     control:Password-With-Header    += 'userPassword'
     control:NT-Password             := 'sambaNtPassword'
   }
 }
```



```
 $ vim /etc/raddb/clients.conf
 client localhost {
         padder          = 127.0.0.1
         secret          = waphpcslab
         shortname       = localhost
         nas_type         = other
 }
 client wap4.lab.hpcs.cs.tsukuba.ac.jp {
         ipv4addr        = 172.16.1.104
         secret          = waphpcslab
         shortname       = wap4
         nas_type        = other
 }
 client wap5.lab.hpcs.cs.tsukuba.ac.jp {
         ipv4addr        = 172.16.1.105
         secret          = waphpcslab
         shortname       = wap5
         nas_type        = other
 }
 client wap6.lab.hpcs.cs.tsukuba.ac.jp {
         ipv4addr        = 172.16.1.106
         secret          = waphpcslab
         shortname       = wap6
         nas_type        = other
 }
```


上から順にサーバ証明書の秘密鍵 (パスフレーズなし)，サーバ証明書，CA 証明書となる．


```
 $ vim /etc/raddb/mods-enabled/eap
 tis-config tis-common {
   private_key_file =  /etc/pki/tls/auth.key
   certificate_file = /etc/pki/tls/certs/auth.lab.hpcs.cs.tsukuba.ac.jp.cer
   ca_file =  /etc/pki/nii-odca3sha2.cer
   dh_file = ${certdir}/dh
   random_file = ${certdir}/random
 }
```



```
 $ vim /etc/raddb/radiusd.conf
 cadir   = /etc/pki/tls/certs
 user = root
 group = root
```


下記の2つで post-auth の LDAP を有効にしないこと．
これをすると LDAP の description attribute に書き込みを行う．
認証時の時間などを任意で書き込めるが，書き込みできる LDAP cn とパスワードがいるので使用しない．


```
 $ vim /etc/raddb/sites-enabled/default
 authorize {
   ldap
 }
 authenticate {
   Auth-Type LDAP {
     ldap
   }
 }
```



```
 $ vim /etc/raddb/site-enabled/inner-tunnel
 listen {
   ipaddr = *
 }
 authorize {
   ldap
 }
 authenticate {
   Auth-Type LDAP {
     ldap
   }
 }
```


シンボリックリンクで LDAP を有効化し，サービスを起動．


```
 $ cd /etc/raddb/mods-enabled/
 $ ln -s ../mods-available/ldap ldap
 $ systemctl enable radiusd
 $ systemctl start radiusd
```


### radiusd.conf の編集
証明書がrootでないと読めないので，下記のように設定

```
 user = root
 group = root
```


### RADIUS のテスト
サーバ上でデバッグ実行

```sh
radiusd -X
```
別のコンソールで以下のコマンドで認証できるかテスト．

```sh
radtest &lt;LDAPユーザ名&gt; &lt;LDAPパスワード&gt; localhost 0 waphpcslab
```

## AP 側のセットアップ
Web UI から操作．
1. 「RADIUS設定」でプライマリRADIUSサーバを 172.16.0.1 に設定，shared secret は waphpcslab
1. 「無線セキュリティー」で認証方式を WPA-EAP に変更，WPA タイプは WPA2-EAP，追加認証はしない

## AP への接続
あとはLDAPのユーザアカウントで接続できるかを確かめる．

