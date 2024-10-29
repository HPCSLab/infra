# HPCS 基幹系 Ansible

## 動かし方

```
ansible-playbook -i hosts.yaml playbook.yaml -K --ask-vault-password
```

実行すると以下を尋ねられるので入力する。

- `BECOME password`: ansibleがsudoに使うパスワード。自分がssh時に使っているユーザーのパスワードを入力。
- `Vault password`: 基幹系のパスワード。他のAdminに聞いてください。
