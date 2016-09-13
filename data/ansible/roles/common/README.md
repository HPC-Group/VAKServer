# Ansible common role

It's a simple role to be applied to all hosts. It just installs a bunch of packages.

## Dependenices

- ANXS.timezone

## Role variables

The following variables are available:

```yaml
my_common_timezone: 'Europe/Berlin'
```
Sets the timezone.

```yaml
my_common_packages:
    - git
    - curl
    - build-essential
    - htop
    - zsh
    - wget
```
Just set an array of packages to be installed.

## Tags

This role makes vivid use of tags.
The following tags are available:

  - common-setup
  - common
  - packages-install

## Example playbook


```yaml
---
#playbook.yml

- name: common-setup
  hosts: all
  remote_user: root
  sudo: yes

  roles:
    - VAK.common

```

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Would be create if you added unit tests, that's on my todo list aswell :]

1. Fork it
2. Create your feature branch (git checkout -b feature/my-cool-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin feature/my-new-feature)
5. Create new Pull Request


