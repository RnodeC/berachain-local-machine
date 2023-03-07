# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "polar"
  config.vm.define "polar"
  config.vm.network "forwarded_port", guest: 26656, host: 26656

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  config.vm.synced_folder "/mnt/data/beranode", "/berachain"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = "32000"
  end

  config.vm.provision "shell", path: "./provision.sh", privileged: false
end
