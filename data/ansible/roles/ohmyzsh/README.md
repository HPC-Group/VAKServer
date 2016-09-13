# Ansible Role: OhMyZsh 

This role will assume the following configuration:
- Install ohmyzsh globally
- Setup a local zshrc file

## Requirements

- Ansible 1.7.2+

## Dependencies

None.

## Installation

Using ansible galaxy:

```bash
ansible-galaxy install vak.ohmyzsh
```
You can add this role as a dependency for other roles by adding the role to the meta/main.yml file of your own role:

```yaml
dependencies:
  - { role: vak.ohmyzsh }
```

## Role Handlers

None

## Role Variables

|Name|Default|Type|Description|
|----|----|-----------|-------|
`vak_ohmyzsh_users`|Array|Array|Collection of users with ohmyzsh custom configurations.
`user.name`|-|String|Name of the user (Need to match a unix system username).
`user.theme`|-|String|OhMyZsh theme see: [OhMyZsh themes](https://github.com/robbyrussell/oh-my-zsh/wiki/themes).
`user.plugins`|-|Array|Array of ohmyzsh plugins see: [OhMyZsh plugins](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins)

### Configuration example

```yaml
---

vak_ohmyzsh_users:
  - name:    root
    theme:   pygmalion
    plugins: ['debian', 'common-aliases', 'history', 'history-substring-search']
  - name:    vak
    theme:   pygmalion
    plugins: ['debian', 'common-aliases', 'history', 'history-substring-search']
```

## Example playbook

```yaml
    - hosts: servers
      roles:
         - { role: vak.ohmyzsh }
```

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Would be create if you added unit tests, that's on my todo list aswell :]

1. Fork it
2. Create your feature branch (git checkout -b feature/my-cool-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin feature/my-new-feature)
5. Create new Pull Request
