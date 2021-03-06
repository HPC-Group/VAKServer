# Ansible project_setup role

This role creates users, groups and folders specific to a project.

## Requirements

None.

## Role variables

The following variables are available:

```
project_user: vak
```
String: The project user you want to be the owner of the folders and files you are using.
Creates a user with a home directory: e.g. ```/home/vak```.
No default, because it's highly project specific

```
project_folder_group: 'www-data'
```
String: The group a specific folder is owned by. 
No default, because it's highly project specific

```
project_user_groups: 
  - root
  - deploy
  - www-data
```
Array: The list of groups the above mentioned user is part of.
Again there are no defaults.

```
project_folders: 
  - /home/vak/my_project
  - /home/vak/my_project_data
```
Array: List of project folders that are going to be created

## Tags

This role makes vivid use of tags.
The following tags are available:

- project-setup
- folders
- groups
- user

## Example playbook


```
- name: create-project-structure
  hosts: all
  remote_user: root
  sudo: yes
  roles:
    - role: vak.project_setup
      project_user: vak
      project_groups:
        - deploy
        - root
        - www-data
      project_folder_group: www-data
      project_folders: 
        - /home/vak/my_project
        - /home/vak/my_project_data
```

## Contributing

In lieu of a formal styleguide, take care to maintain the existing coding style. Would be create if you added unit tests, that's on my todo list aswell :]

1. Fork it
2. Create your feature branch (git checkout -b feature/my-cool-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin feature/my-new-feature)
5. Create new Pull Request