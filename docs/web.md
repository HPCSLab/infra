# Web

以下のサービスをtraefikで管理している。

- phpldapadmin
- hpcs-web
- fallback

## [traefik](https://traefik.io/traefik/)

単一ホストで複数ドメインを扱い、fallbackとそれ以外を同じドメインでホストするためのrproxy。
TLSはTraefikがLet's Encryptの証明書を自動更新して終端する。

## phpldapadmin

`osixia/phpldapadmin:latest`をベースとしてテンプレートを追加したイメージをビルドして使用。

## hpcs-web

[web](https://github.com/hpcslab/web)にコードが存在。Astroで書かれたページをビルドしてGHCRに保存。
ファイルも含まれているのでPullして起動するだけ。

## fallback

PHP 8.1入りのApache HTTP2コンテナを、NFSディレクトリをマウントして起動。
hpcs-webのパスに含まれないものは全てこちらに流される。

