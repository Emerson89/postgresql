# Postgresql Database and TimescaleDB

Postgresql database installation using ansible

## Dependências
![Badge](https://img.shields.io/badge/ansible-2.9.10-blue)

## Suporte SO

- Ubuntu20
- Debian10
- Rocky8
- Centos8

# Como Usar!!!

## Crie o arquivo de inventário hosts 

## Variáveis
| Nome | Descrição | Default | 
|------|-----------|---------|
| postgresql_databases | List databases | [] |
| postgresql_users | List users | [] | 
| pg_hba_config | IP para acesso remoto ao banco | [] |
| timescaledb_install | Habilitar timescaledb | False|

## Exemplo de playbook para instalação
```
---
- name: Install Database
  hosts: all
  become: true
  roles:
    - postgresql
```

*Inside vars.yml:*

```
## Access remote

pg_hba_config:
  - remote_address: 172.16.3.10
  - remote_address: 172.16.3.11
  - remote_address: 172.16.3.12

postgresql_databases:
  - name: "db"
    encoding: utf8
    collation: utf8_bin
postgresql_users:
  - name: "dbuser"
    password: "yQE9ob2yqR4=xxtttrr5"
```

## Example inventory

```bash
[all]
127.0.0.1 ansible_ssh_private_key_file=PATH/private_key 

[all:vars]
ansible_user=username
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

## Exemplo execute o playbook

- Use Basic

``` 
ansible-playbook -i hosts playbook.yml --extra-vars "@vars.yml"
```

- Use vars

``` 
ansible-playbook -i hosts playbook.yml --extra-vars "@vars.yml"
```

## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
