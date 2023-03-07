#!/usr/bin/env bash

set -eu 

sudo apt update -y
sudo apt install jq git -y

curl -LO https://go.dev/dl/go1.20.1.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.20.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
echo "export PATH=$PATH:/usr/local/go/bin:$(/usr/local/go/bin/go env GOPATH)" >> $HOME/.bashrc 

curl -L https://foundry.paradigm.xyz | bash

git clone https://github.com/berachain/polaris
pushd polaris
git checkout main
go run build/setup.go

mage install

mage start