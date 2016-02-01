InnoHub Ansible : ruby-install [![Build Status](https://travis-ci.org/innohub-ansible/ruby-install.svg?branch=master)](https://travis-ci.org/innohub-ansible/ruby-install)
==========================================================================================================================================================================

Installs ruby-install.

Requirements
------------

Works ONLY on Ubuntu 14.04.

Role Variables
--------------

ruby_install_version : defaults to '0.4.3'

Dependencies
------------

None

Example Playbook
----------------

Example Playbook:

    - hosts: servers
      roles:
         - { role: innohub-ansible.ruby-install }

Example Role:

    dependencies:
      - { role: ruby_install }

License
-------

MIT
