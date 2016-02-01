# Ansible Role For ImageMagick

[![Build Status](https://circleci.com/gh/crushlovely/ansible-imagemagick.svg?style=shield)](https://github.com/crushlovely/ansible-imagemagick)
[![Current Version](http://img.shields.io/github/release/crushlovely/ansible-imagemagick.svg?style=flat)](https://galaxy.ansible.com/list#/roles/1180)

This an Ansible role that installs [ImageMagick](http://www.imagemagick.org/) and its dependencies via `apt` on a server running Ubuntu 12.04LTS and up.

## Installation

``` bash
$ ansible-galaxy install crushlovely.imagemagick,v1.0.0
```

## Usage

Once this role is installed on your system, include it in the roles list of your playbook.

``` yaml
---
- hosts: localhost
  roles:
    - crushlovely.imagemagick
```

## Dependencies

None

## License

MIT
