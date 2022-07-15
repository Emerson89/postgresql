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
| database_name | Nome database | db01 |
| database_user | Nome user | user01 | 
| db_pass | Senha user | Mdfrty2 |
| remote_address | IP para acesso remoto ao banco | 127.0.0.1 |
| database_address | IP database | 127.0.0.1 |
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
## Exemplo execute o playbook
``` 
ansible-playbook -i hosts playbook.yml --extra-vars "database_name=exemplo-1 database_user=exemplo-2 db_pass=exemplo-3"
ansible-playbook -i hosts playbook.yml --extra-vars "database_name=exemplo-1 database_user=exemplo-2 db_pass=exemplo-3 remote_address=IP-REMOTO" <----Acesso remoto
```
## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
