Ansible Nginx/Unicorn setup
===========================

This Ansible role installs Nginx and generates configuration for Unicorn
applications

Requirements
------------

None

Notes
-----

This role does not install or configure Unicorn itself. It is designed
to play nicely with a Unicorn role such as
[Unicorn-RVM](https://github.com/agios/ansible-unicorn-rvm).

Role Variables
--------------

-   `nginx_sites` is an array of unicorn sites, defaults to `[]`

    Each nginx_sites entry is a dict with the following options:

    -   `name` (eg `my_app`, required)
    -   `server_name` (eg `my-app.my-domain.org`, required, in any
        format supported by nginx)
    -   `root` defaults to `/var/www/{{ name }}/current` (Capistrano
        compatible)
    -   `listen` defaults to `[::]:80` (Both IPv4 and IPv6)
    -   `access_log` is a dict with the following options:
        -   `path` defaults to `/var/log/nginx/{{ name }}.access.log`
        -   `format` is optional, can be used to specify a custom nginx
            log output format
    -   `error_log` see above
    -   `ssl` if this option is given, an ssl config section will be
        generated. It contains the following options:
        -   `certificate` required, path to ssl certificate
        -   `certificate_key` required, path to ssl certificate key
        -   `ssl_only` if set to `true`, always redirect to ssl
        -   `spdy` if set to `true`, enable spdy support
        -   `gzip_assets` if set to `true`, enable serving gzipped
            'assets' folder, cached for 16w (useful for rails with asset
            precompilation)
        -   `sensitive_uris` required unless `ssl_only`, nginx uri
            expressions that will be served using https
        -   `access_log` as above, for https requests
        -   `error_log` as above, for https requests




Example Playbook
----------------

The role could be included in a playbook as follows (unicorn-rvm also
shown):

```yaml
---
-hosts: application
  roles:
    - role: unicorn-rvm
      rails_apps:
        - { name: 'my_app1', ruby_version: 'ruby-1.9.3' }
        - { name: 'my_app2', ruby_version: 'ruby-2.1.1', root: '/var/test_apps/app2', env: staging }
    - role: nginx-unicorn
      nginx_sites:
        - name: 'my_app1'
          server_name: 'my-app1.example.com'
          access_log:
            format: 'main'
          ssl:
            certificate: /etc/ssl/localcerts/my_app1.pem
            certificate_key: /etc/ssl/localcerts/my_app1.key
            sensitive_uris:
              - ^/user/sign_in(.*)
              - ^/user/password(.*)
            access_log:
              format: 'main'
        - name: 'my_app2'
          server_name: 'my-app2.example.com *.mydomain.com'
          root: '/var/test_apps/app2'
          ssl:
            certificate: /etc/ssl/localcerts/my_app2.crt
            certificate_key: /etc/ssl/localcerts/my_app2.key
            ssl_only: true
```

License
-------

MIT

