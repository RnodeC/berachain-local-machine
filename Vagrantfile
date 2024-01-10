Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.hostname = "bera"
  config.vm.define "bera"

  config.vm.synced_folder "/mnt/data/berachain", "/berachain"
  config.vm.network "forwarded_port", guest: 26656, host: 26656
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = "32000"
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "myplaybook.yaml"
    ansible.groups = {
      "rpc" => ["bera"],
      "rpc:vars" => {"berachain_role" => "rpc"}
    }
  end
end
