Ansible-Sqlite
========

An ansible role for installing sqlite, and setting up databases. Part of a [tutorial](http://probablyfine.co.uk/2014/03/27/how-to-write-an-ansible-role-for-ansible-galaxy/).

Role Variables
--------------

 * `sqlite_dir` - directory in which to create the database files. Defaults to `/var/lib/sqlite`
 * `sqlite_dbs` - list of files to create under `sqlite_dir`

Example Playbook
-------------------------

    - hosts: all
      roles:
         - { role: mrwilson.sqlite, sqlite_dir: /opt/sqlite, sqlite_dbs: [ foo, bar ] }

License
-------

MIT
