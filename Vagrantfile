# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
#!/usr/bin/env bash

set -eu 

echo "[INFO] Updating os"
sudo apt update -y
sudo apt install -y \
  jq \
  git \
  gcc \
  ca-certificates \
  curl \
  gnupg \
  lsb-release


echo "[INFO] Installing go"
curl -LO https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
echo "export PATH=$PATH:/usr/local/go/bin:$(/usr/local/go/bin/go env GOPATH)/bin" >> $HOME/.bashrc 
go env -w CGO_ENABLED=1

echo "[INFO] Installing docker"
sudo mkdir -m 0755 -p /etc/apt/keyrings
cat docker-gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
sudo usermod -aG docker vagrant

echo "[INFO] Installing foundry"
FOUNDRY_DIR=${FOUNDRY_DIR-"$HOME/.foundry"}
FOUNDRY_BIN_DIR="$FOUNDRY_DIR/bin"
FOUNDRY_MAN_DIR="$FOUNDRY_DIR/share/man/man1"
BIN_URL="https://raw.githubusercontent.com/foundry-rs/foundry/master/foundryup/foundryup"
BIN_PATH="$FOUNDRY_BIN_DIR/foundryup"
mkdir -p $FOUNDRY_BIN_DIR
mkdir -p $FOUNDRY_MAN_DIR
curl -# -L $BIN_URL -o $BIN_PATH
chmod +x $BIN_PATH
PROFILE=$HOME/.bashrc
PREF_SHELL=bash
if [[ ":$PATH:" != *":${FOUNDRY_BIN_DIR}:"* ]]; then
  echo >> $PROFILE && echo "export PATH=\"\$PATH:$FOUNDRY_BIN_DIR\"" >> $PROFILE
fi
./.foundry/bin/foundryup

echo "[INFO] Getting polaris and setting up build"
git clone https://github.com/berachain/polaris
pushd polaris
git checkout main
go run magefiles/setup/setup.go

echo "[INFO] Building polard"
mage cosmos:build
popd
SCRIPT

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "polar"
  config.vm.define "polar"
  
  config.vm.synced_folder "/mnt/data/beranode", "/berachain"
  config.vm.network "forwarded_port", guest: 26656, host: 26656
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = "32000"
  end

  config.vm.provision "file", source: "docker-gpg.key", destination: "docker-gpg.key"
  config.vm.provision "shell", inline: $script, privileged: false
end
