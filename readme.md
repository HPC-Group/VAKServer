# VAK StateLogger Backend

This repository is responsible for installing and configuring the VAK StateLogger Backend.
It provisions a multi tier environment, with different stages.

In detail it installs [couchbase-server](http://developer.couchbase.com/documentation/server/4.0/introduction/intro.html) and the acompaning [sync_gateway](http://developer.couchbase.com/documentation/mobile/1.1.0/get-started/sync-gateway-overview/index.html) to be able to send logs from any mobile device to a remote location. An overview can be seen in the following figure:

![Couchbase / Sync Gateway / Couchbase Lite - Architecture](http://images.cbauthx.com/Mobile/1.1.0/20150922-180958/sync-gateway.svg)
(Figure taken from http://developer.couchbase.com/documentation/mobile/1.1.0/get-started/sync-gateway-overview/index.html)

Each of these components ships (Couchbase Server and Sync Gateway) in a docker container. The components are orchestrated through docker-compose and are by default configured to
communicatie with each other.

## Requirements

This is currently only tested on a  OSX 10.11 host, but should work perfectly fine on any *nix system and should also work on a windows host.

### Required software

If you are on OSX you probably have [homebrew](http://brew.sh/) installed, if not you are definitely missing out, so be sure to have it ready.
Also to be able to use the local development environment this tool relies on the availabilty of [vagrant](https://docs.vagrantup.com/v2/why-vagrant/index.html) and [virtualbox](https://www.virtualbox.org/) or any other provider that is supported by vagrant. A list of providers can be found in the vagrant [documentation](https://docs.vagrantup.com/v2/providers/index.html).

One can install vagrant, virtualbox and lots of other tools via brew-cask, so be sure to have that installed as well.

To ease the usage of the backend component in the local environment, where you usually don't have a DNS-server running, I suggest installing
the vagrant plugin [hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater).  The plugin takes care of adding and removing your project hostname defined in the Vagrantfile to '/etc/hosts' on vagrant up and vagrant destroy. It only adds the entry on the initial vagrant up.
Because we are editing a system file you have to have sudo privileges.

### Preparations and Installation

(OSX specific) The following commands can be used to prepare your local machine:

__Preparations__

```bash

# GET CASK
brew install caskroom/cask/brew-cask

# GET vagrant and virtualbox 
brew cask install vagrant virtualbox 

# if you have another virtualization platform installed and would rather use that instead please check if vagrant supports said platform.
# eventually you'll need to add the platform to the vagrant file. currently only virtualbox and parallels are supported.
# if you for example chose the "parallels"-platform make sure to install the "vagrant-parallels" plugin
# vagrant plugin install vagrant-parallels

# Optionally install vagrant hostsupdater
vagrant plugin install vagrant-hostsupdater

# install ansible
brew install ansible

# add a ssh key to ~/.ssh
ssh-keygen -t rsa -b 4096 -C 'vak-statelogger-backend' -f ~/.ssh/vagrant_ssh

# Add the following to your ssh-config located at ~/.ssh/config which creates a ssh configuration entry.
# for better readability the follwing is just appended to ~/.ssh/config file
#
# Host  vak.telemetry.dev
#   Hostname 192.168.34.11
#   Identityfile ~/.ssh/vagrant_rsa
#   StrictHostKeyChecking no
#   User root
#   LogLevel ERROR

echo 'Host vak.telemetry.dev\n\tHostname 192.168.34.11\n\tIdentityfile ~/.ssh/vagrant_rsa\n\tStrictHostKeyChecking no\n\tUser root\n\tLogLevel ERROR \n\n' >> ~/.ssh/config

```

__Installation__

The tool is kind of opinionated about how to use vagrant. So in general one would just ```vagrant up``` and if one needed to get onto the vagrant machine just use ```vagrant ssh```. That way is also obviously working in this environment but is strongly discouraged. 
There is also no provisioning on ```vagrant up```. I chose it to be that way because my different environments should all resemble the production environment as much as possible. The advantage of this is that the deploy/orchestration/provisioning scripts are thoroughly tested - currently not in a repeatable way through tools like [serverspec](http://serverspec.org/), [test-kitchen](http://kitchen.ci/docs/getting-started/) or alike - but by intense work and sweat :]. Therefore the deployment to the different stages should be fairly easy and straight forward.

This is by nomeans trying to be a full documentation for vagrant but one needs to know the basic commands provided. For the full documentation either enter ```vagrant --help``` or visit the [command line documentation](https://docs.vagrantup.com/v2/cli/index.html).

The commands most often needed are the follwing:

- vagrant up => starts a virtualmachine defined by a corresponding Vagrantfile
- vagrant reload => reloads the virtualmachine
- vagrant suspend => suspend state of the machine, keeps everything saved, like hibernate
- vagrant destroy => destroys the machine, great if you want to start over

__Starting vagrant__

```bash

# change to the working directory where you cloned or copied this repository
cd /path/to/this-repository

# add a Ubuntu base box to be exact Trusty x64
# that might take a while, because you are downloading the image
vagrant box add ubuntu/trusty64

# optinonal add another base box
# for example the openSUSE-13.2 image from webhippie
# again this takes some time
vagrant box add webhippie/opensuse-13.2

# you can also set the VAK_PROVIDER environment variable to 'parallels' to use that virtualization provider
# when the boxes have finished downloading `vagrant up` will start a virtualmachine with ubuntu/trusty64
# optional: `box_type=opensuse vagrant up` will boot a virtualmachine with opensuse-13.2
# remark: sadly this only works on the initial vagrant up : `[
vagrant up

# if you have chosen to install the hostsupdater plugin you will now be asked to enter your password.
#
# when the command ran successfully you should be able to ssh into it by just entering
ssh vak.telemetry.dev 

# welcome to you newly created virtualmachine :]
```

Now you are good to go and provision your machine like you would with any other remote machine.

__Provision and orchestrate the backend__

```bash

# change to the ansible folder 
cd ./data/ansible

# we are assuming the single host vagrant environment 
# all the necessary dependent roles are located in the "roles"-folder.
# if you are ready to provison your machine enter this cmd:
ansible-playbook install.yml

# for another environment like the staging server call the following command:
# ansible-playbook install.yml -i env/staging --ask-become-pass
# you will be prompted to enter a sudo password so, that ansible is able to provision the machine

```

When everything went well you can now visit your newly installed couchbase server and your sync_gateway.


### Couchbase Server

The default location of the couchbase-server is http://VAK.telemetry.dev:8091

To login into the server you need to enter the follwing credentials:

- user: desmond
- password: secret_password

### Views

The following depicts a session view:

```javascript
function (doc, meta) {
  if(doc.type && doc.type === 'session') {
    emit(doc.entityId, [doc.alias, doc.startTimestamp]);
  }
}
```
Make sure to select "descending" in the filter results.

### Sync Gateway

The default location of the sync_gateway is http://VAK.telemetry.dev:4985.

The sync gateway also sets a user and password:

- user: hurley
- password: secret_password

It's also possible to disable the GUEST user by specifing ```sync_gateway_config_disable_guest: "true"```.
The complete configuration keys and their corresponding values can be scrutinzed [here](http://developer.couchbase.com/documentation/mobile/1.1.0/develop/guides/sync-gateway/configuring-sync-gateway/config-properties/index.html).