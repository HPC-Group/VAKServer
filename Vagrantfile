#!/usr/bin/env ruby

# method to insert a ssh key into the vm
require_relative './data/ansible/utils/key_authorization'

# prebuilt image types
#  those are the defaults if the provider is set to virtualbox
# more machines are available at https://atlas.hashicorp.com/boxes/search
ubuntu_box =  'ubuntu/trusty64'
open_suse_box = 'webhippie/opensuse-13.2'

box_type = ubuntu_box

ip_address = '192.168.34.11'
rsa_key = '~/.ssh/vagrant_rsa.pub'
host_name = 'vak.telemetry.dev'

# https://docs.vagrantup.com/v2/providers/index.html
# possible values: docker, vmware, hyper-v
# additional plugins are available
vm_provider = 'virtualbox'

if (ENV['VAK_PROVIDER'].to_s == 'parallels')
  vm_provider = ENV['VAK_PROVIDER']
  ubuntu_box = 'parallels/ubuntu-14.04'
  open_suse_box = 'bento/opensuse-13.2-x86_64'
end

if (ENV['box_type'].to_s == 'opensuse')
  box_type = open_suse_box
end

# ports that should be forwarded to the host
ports = [
  { 'guest' => 3000, 'host' => 3000 }, # application
  { 'guest' => 8091, 'host' => 8091 },  # couchbase server admin panel
  { 'guest'=> 11210, 'host' => 11210 }, # client
  { 'guest'=> 4984, 'host' => 4984 }, # gateway
  { 'guest' => 4985, 'host' => 4985 } #gateway
]

Vagrant.configure(2) do | config |

  # inserts a key into the machine so we can work on it
  # emulates a remote machine workflow
  # otherwise using vagrant ssh also works
  authorize_key_for_root config, rsa_key

  # disable librarian chef plugin
  if Vagrant.has_plugin?('vagrant-librarian-chef')
    config.librarian_chef.enabled = false
  end

 # disables removal of the /etc/hosts  'vak.telemetry.dev 192.168.34.11' entry on suspend
  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = false
  end

  # configure vm values
  config.vm.hostname = host_name
  config.vm.box = box_type
  config.vm.network 'private_network', ip: ip_address
  config.vm.synced_folder './shared/app', '/home/vak/app'

  # forward given ports: see ports array
  ports.each do | port |
    config.vm.network 'forwarded_port', guest: port['guest'], host: port['host']
  end

  # customize vm provider
  config.vm.provider vm_provider do | vb |
    vb.memory = 2048
    vb.cpus = 2
  end
end
