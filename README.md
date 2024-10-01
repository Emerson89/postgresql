# Postgresql Database and TimescaleDB

**ansible for installation, users creation, databases, permissions, dump and restore database Postgresql** 

## Dependencies

- ansible-2.16.6
- psycopg2 >= 2.5.1
- community.postgresql

## Suport SO

- Ubuntu20
- Debian10
- Rocky8
- Centos8

# how to use!!!

## Variables
| Name | Description | Default | 
|------|-----------|---------|
| postgresql_databases | List databases | [] |
| postgresql_users | List users | [] | 
| pg_hba_config | IP for remote access to the bank | [] |
| timescaledb_install | Enabled timescaledb | false|
| install_postgresql | Install postgresql in VM | false|
| postgresql_dump_restore | Enabled dump or restore database | false|
| create_users_postgresql | Enabled create users only remote use | false|
| users_privs_postgresql | Enabled modification of privileges | false|
| copy_restore | Enable copy local file to remote using for restore dump | false|
| path_file | Path local file to remote using for restore dump | ""|

## Pass user postgres

Through the module *postgresql_query* is performed the alter user and generated random password of the user postgres and saved in the root of the project in the file *passwordfile* 

```yaml
- name: Alter user postgres
  postgresql_query:
    db: postgres
    query: ALTER USER postgres WITH PASSWORD '{{ lookup('ansible.builtin.password', 'passwordfile', length=21, chars=['ascii_lowercase', 'ascii_uppercase', 'digits']) }}'
```

## Example playbook for postgresql installation on VM

```yaml
---
- name: Install Database
  hosts: all
  become: true
  roles:
    - postgresql
```

*Inside vars.yml:*

```yaml
install_postgresql: true

## Access remote

pg_hba_config:
  - remote_address: 172.16.3.10
  - remote_address: 172.16.3.11
  - remote_address: 172.16.3.12

postgresql_databases:
  - name: "db"
    encoding: utf8
    collation: utf8_bin
    template: template0
    lc_collate: en_US.UTF-8
    lc_ctype: en_US.UTF-8
postgresql_users:
  - name: "dbuser"
    password: "yQE9ob2yqR4=xxtttrr5"
```

- Copy dump local for remote

```yaml
install_postgresql: true
create_users_postgresql: true
postgresql_dump_restore: true
copy_restore: true
path_file: "dump_restore.sql"

pg_hba_config:
  - remote_address: 172.16.3.11

postgresql_databases:
  - name: "loja"
    encoding: utf8
    collation: utf8_bin
    template: template0
    lc_collate: en_US.UTF-8
    lc_ctype: en_US.UTF-8
postgresql_users:
  - name: "dbuser"
    password: "yQE9ob2yqR4=xxtttrr5"
postgresql_databases_dump_restore:
  - name: "loja"
    state: restore
    target: /home/{{ ansible_user }}/dump_restore.sql 
```    

## Inventory example

```bash
[all]
127.0.0.1 ansible_ssh_private_key_file=PATH/private_key 

[all:vars]
ansible_user=username
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

## Example run the playbook

```bash
ansible-playbook -i hosts playbook.yml --extra-vars "@vars.yml"
```

## Example of playbook user creation, databases, dump, restore or privilege change

```yaml
---
- name: Postgresql tasks
  hosts: localhost
  connection: local
  roles:
    - postgresql
```

*Inside vars.yml:*

```yaml
ppostgresql_dump_restore: true
users_privs_postgresql: true
create_users_postgresql: true

# Create Users
### https://docs.ansible.com/ansible/latest/collections/community/postgresql/postgresql_user_module.html#ansible-collections-community-postgresql-postgresql-user-module
postgresql_users:
  - name: "dbuser"
    password: "yQE9ob2yqR4=xxtttrr5"
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"
    ## Only needed when remote connection
    become: false
    postgresql_user: ""

# Create Database
### https://docs.ansible.com/ansible/latest/collections/community/postgresql/postgresql_db_module.html#ansible-collections-community-postgresql-postgresql-db-module
postgresql_databases_dump_restore:
  - name: "db2"
    encoding: utf8
    collation: utf8_bin
    template: template0
    lc_collate: en_US.UTF-8
    lc_ctype: en_US.UTF-8
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"

# Dump and Restore

   ## Connect to the remote host to perform the dump and later do the restore
  - name: "store"
    state: dump
    target: loja_dump_remote.sql
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"
   ## Connect to the remote host to perform the dump and later do the restore  
  - name: "store_restore"
    encoding: utf8
    collation: utf8_bin
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"
  - name: "store_restore"
    state: restore
    target: loja_dump_remote.sql
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"

# Permissions
### https://docs.ansible.com/ansible/latest/collections/community/postgresql/postgresql_privs_module.html#ansible-collections-community-postgresql-postgresql-privs-module

## GRANT ALL PRIVILEGES ON DATABASE db TO dbuser
postgresql_users_privs:
  - database: "db"
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"
    roles: "dbuser"
    type: database
    privs: ALL
    grant_option: true
    ## Only needed when remote connection
    become: false
    postgresql_user: ""

## REVOKE ALL PRIVILEGES ON DATABASE db TO dbuser
  - database: "db"
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"
    roles: "dbuser"
    type: database
    privs: ALL
    state: absent
    ## Only needed when remote connection
    become: false
    postgresql_user: ""

## GRANT ALL PRIVILEGES ON ALL TABLES db TO dbuser
  - database: "db"
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"
    roles: "dbuser"
    type: table
    schema: public
    objs: ALL_IN_SCHEMA
    privs: ALL
    grant_option: true
    ## Only needed when remote connection
    become: false
    postgresql_user: ""

## GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE customers,products,orders,itens_request TO dbuser;
  - database: "store"
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"
    roles: "dbuser"
    type: table
    schema: public
    objs: customers,products,orders,itens_request
    privs: SELECT,INSERT,UPDATE,DELETE
    ## Only needed when remote connection
    become: false
    postgresql_user: ""

## REVOKE INSERT, UPDATE ON TABLE customers,products,orders,itens_request FROM dbuser
  - database: "store"
    login_host: <IP-HOST-REMOTE>
    login_user: "postgres"
    login_password: "N2knc7Dig3LoPMNE0HQVB"
    roles: "dbuser"
    type: table
    schema: public
    objs: customers,products,orders,itens_request
    privs: SELECT,INSERT,UPDATE,DELETE
    state: absent
    ## Only needed when remote connection
    become: false
    postgresql_user: ""
```

```bash
ansible-playbook playbook.yml --extra-vars "@vars.yml"
```

## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
