#!/bin/sh

set -eux

cp /etc/letsencrypt/live/idm.hpcs.cs.tsukuba.ac.jp/fullchain.pem /var/lib/kanidm/chain.pem
cp /etc/letsencrypt/live/idm.hpcs.cs.tsukuba.ac.jp/privkey.pem /var/lib/kanidm/key.pem

chown idm:idm /var/lib/kanidm/chain.pem
chown idm:idm /var/lib/kanidm/key.pem

systemctl restart kanidm
