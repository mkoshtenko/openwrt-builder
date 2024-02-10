# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "debian/bookworm64"

  # Disable default shared folder.
  config.vm.synced_folder ".", "/vagrant", disabled: true
  # Share folders.
  config.vm.synced_folder "scripts/", "/home/vagrant/scripts"
  config.vm.synced_folder ".builds/", "/home/vagrant/builds", create: true

  # Provider-specific configuration
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "512"
  end
  

  # Enable provisioning with Ansible
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end
end

