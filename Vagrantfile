# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
#!/usr/bin/env bash

set -eu 

echo "[INFO] Updating os"
sudo apt update -y
sudo apt install jq git -y


echo "[INFO] Installing go"
curl -LO https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
echo "export PATH=$PATH:/usr/local/go/bin:$(/usr/local/go/bin/go env GOPATH)/bin" >> $HOME/.bashrc 

echo "[INFO] Installing foundry"
curl -L https://foundry.paradigm.xyz | bash

echo "[INFO] Getting polaris and setting up build"
git clone https://github.com/berachain/polaris
pushd polaris
git checkout main
go run magefiles/setup/setup.go

echo "[INFO] Building polard"
mage test
popd
SCRIPT

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

  config.vm.provision "shell", inline: $script, privileged: false
end
