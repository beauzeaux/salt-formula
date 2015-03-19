# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "salt"
  config.vm.synced_folder "./dev/state", "/srv/salt", id: "salt"
  config.vm.synced_folder "./dev/pillar", "/srv/pillar", id: "pillar"

  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  
  config.vm.provision :salt do |salt|
    #salt.verbose = true
    #salt.install_master = true
    #salt.install_type = 'git'
    salt.install_args = '-g https://github.com/beauzeaux/salt.git git gce-scopes'
    salt.minion_config = 'dev/minion'
    salt.run_highstate = true
  end  
end
