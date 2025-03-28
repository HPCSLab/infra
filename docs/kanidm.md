## 作業手順

### パッケージインストール

ansibleを回してnginxのセットアップとcertbotのインストールまで行う

### 初期証明書を作成

```
certbot certonly --nginx -d idm.hpcs.cs.tsukuba.ac.jp -m hpcs-admin@hpcs.cs.tsukuba.ac.jp
```

### デプロイスクリプト配置

再びansibleを回す。正しく最後まで完了するのを確認。
