# 新しく Admin 担当になった方へ

Admin を担当してくださりありがとうございます。これから研究以外にサーバ保守の点で作業が増える場合がありますが、協力して進めてくだると幸いです。
現在admin向けのドキュメントはこのリポジトリへ移行中ですが、古い情報はPukiwikiに残っています。
不明点があれば Pukiwiki を参照するか、現役のadminに相談してください。

## 仕事内容

- 年度初め作業
  - [新入生のアカウントセットアップ](./onboarding.md)
- 停電作業
  - 毎年10月に全学停電があるので対応を行います
  - [停電対応マニュアル](./poweroutage.md)
- その他システム更新、改良
  - 必須ではないですがなるべく参加して欲しいです
  - [Admin issues](https://github.com/hpcslab/admin-issues)

## 新adminチェックリスト

以下のテンプレートをコピーしてIssueを作成してください。

| 現役adminが作業 | 新adminが作業 | タスク                                                                        | チェック条件                                      |
| :-------------- | :------------ | :---------------------------------------------------------------------------- | :------------------------------------------------ |
|                 | [ ]           | 作業端末のセキュリティ対策                                                    | セキュリティ対策を行なっているか？                |
| [ ]             |               | 基幹 LDAP の HPCS-ADMIN グループ追加                                          | id コマンドで HPCS-ADMIN グループが表示されるか？ |
| [ ]             | [ ]           | gwへの公開鍵登録                                                              | 登録したか？/SSH可能か？                          |
| [ ]             | [ ]           | kvm-servへの公開鍵登録                                                        | 登録したか？/SSH可能か？                          |
| [ ]             | [ ]           | `node0`, `node1`での公開鍵登録(ansible経由)                                   | 登録したか？/SSH可能か？                          |
| [ ]             | [ ]           | hpcs-admin,admin-log ML 追加                                                  | 登録したか？/招待メールが届いたか？               |
|                 | [ ]           | [CCS計算機室鍵登録](https://www.hpcs.cs.tsukuba.ac.jp/internal/pukiwiki/?CCS) | リンク先ページの書類をCCSに提出したか？           |
| [ ]             | [ ]           | HPCS Admin カレンダーの招待                                                   | 招待したか？/閲覧可能か？                         |
| [ ]             | [ ]           | Slackの #admin、#admin-monitoring チャンネル招待                              | 招待したか？/閲覧可能か？                         |
| [ ]             | [ ]           | Administration/external-docs の権限移譲                                       | 招待したか？/閲覧可能か？                         |
| [ ]             | [ ]           | GitHubのadminチームへの参加                                                   | 招待したか？/参加したか？                         |

## Tips

### LDAPの操作

詳しくは [LDAPドキュメント](./ldap.md)を参照。

http://phpldapadmin.lab.hpcs.cs.tsukuba.ac.jp を使用する。
BaseDNは `cn=Manager,dc=hpcs,dc=cs,dc=tsukuba,dc=ac,dc=jp` で、パスワードは基幹系パスワード。

### ssh

`gw.hpcs.cs.tsukuba.ac.jp`と`work.hpcs.cs.tsukuba.ac.jp`はインターネットに露出している。
それ以外のノードは内部ネットワークからしかアクセス出来ない。
研究室以外からアクセスする場合、下記の設定を`~/.ssh/config`に追加することを推奨。

HostNameに関しては内部ドメインは外部から解決出来ないので、
`*.lab.hpcs.cs.tsukuba.ac.jp`でまとめずにIPを`HostName`で直接指定する方が良いかもしれない。
必須ではないが、`ControlMaster`を有効化しておくとちょっと接続が早くなる。
踏み台サーバはLDAPのusernameで入るが、その先の内部サーバは基本的に`rescue`アカウントで入る。
adminであれば`work`ではなく`gw`を踏み台サーバとしても良い。

```ssh_config
Host *.lab.hpcs.cs.tsukuba.ac.jp
  ProxyJump hpcs-bastion
  ForwardAgent yes
  User rescue

Host hpcs-bastion
  User mnakano # 自分のユーザー名に変える
  ForwardAgent yes
  HostName  work.hpcs.cs.tsukuba.ac.jp
```
