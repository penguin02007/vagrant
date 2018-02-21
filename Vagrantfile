# -*- mode: ruby -*-
# vi: set ft=ruby :
#required_plugins = %w( vagrant-libvirt )
#required_plugins.each do |plugin|
#  raise "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
#end
Vagrant.configure("2") do |config|
#
# base
#
$script = <<SCRIPT
echo Self provisioning...
apt-get update -y && \
apt-get install python-apt python-minimal -y
SCRIPT
def nat(config)
    config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--nic1", "natnetwork", "--nat-network2", "pxe", "--nictype1","virtio"]
    end
end
  config.vm.box = "ubuntu/xenial64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "1024"]
    # http://www.virtualbox.org/manual/ch09.html#nat-adv-dns
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.linked_clone = true
  config.vm.provision "shell", inline: $script
  end

  config.vm.define "dnsmasq" do |v|
    v.vm.hostname = "dnsmasq.dev"
    v.vm.network "private_network", ip: "192.168.33.31"
  end

  config.vm.define "splunkn1" do |v|
    v.vm.box = "centos/7"
    v.vm.hostname = "splunkn1.dev"
    v.vm.network "private_network", ip: "192.168.33.39"
  end

  config.vm.define "nagioscore" do |v|
    v.vm.box = "daniele2010/ubuntu-14.04_x64-nagios"
    v.vm.hostname = "nagioscore.dev"
    v.vm.network "private_network", ip: "192.168.33.40"
  end

  config.vm.define "puppetmaster" do |v|
    v.vm.hostname = "puppetmaster.dev"
    v.vm.network "private_network", ip: "192.168.33.41"
  end

    config.vm.define "quartermaster" do |v|
#    nat(config)
    v.vm.hostname = "quartermaster.dev"
    v.vm.network "private_network", ip: "192.168.33.42"
  end

    config.vm.define "dev-te01" do |v|
    v.vm.box = "ubuntu/xenial64"
    v.vm.hostname = "dev-te01.dev"
    v.vm.network "private_network", ip: "192.168.33.43"
  end

    config.vm.define "ansible1" do |v|
    v.vm.box = "ubuntu/xenial64"
    v.vm.hostname = "ansible1.dev"
    v.vm.network "private_network", ip: "192.168.33.44"
    config.vm.provision "shell", inline: $script
  end

end
