# -*- mode: ruby -*-
# vi: set ft=ruby :
DOMAIN = '.dev'
boxes =[
  {
    :name => "client1",
    :eth1 => "192.168.0.10",
    :mac1 => "000c295526f9",
    :mem  => "2048",
    :cpu  => "2",
  },
  {
    :name => "server1",
    :eth1 => "192.168.0.11",
    :mac1 => "000c295526f9",
    :mem  => "2048",
    :cpu  => "2",
  }
]
Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    # http://www.virtualbox.org/manual/ch09.html#nat-adv-dns
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.memory = 1024
    vb.cpus = 2
    vb.linked_clone = true
  end

  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name] + DOMAIN
      config.vm.network :private_network, ip: opts[:eth1], mac: opts[:mac1]
      config.vm.provider "virtualbox" do |vb|
        vb.memory = opts[:mem]
        vb.cpus = opts[:cpu]
      end
    end
  end

  config.vm.define "client1" do |v|
    v.vm.provision "ansible" do |ansible|
      ansible.playbook = "iptables.yml"
    end
  end

end
