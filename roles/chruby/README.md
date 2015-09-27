# InnoHub Ansible : chruby [![Build Status](https://travis-ci.org/innohub-ansible/chruby.svg?branch=master)](https://travis-ci.org/innohub-ansible/chruby)

Installs chruby.

Requirements
------------

Tested on Ubuntu 12.04 and 14.04 only.

Role Variables
--------------

chruby_version : defaults to '0.3.9'

Example Playbook
----------------

Example Playbook:

    - hosts: servers
      roles:
         - { role: innohub-ansible.chruby }

Example Role:

    dependencies:
      - { role: chruby }

License
-------

MIT
