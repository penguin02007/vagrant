# -*- mode: ruby -*-
# vi: set ft=ruby :
DOMAIN = '.dev'
plugins=[
  {
    :name    => "vagrant-scp",
    :version => ">= 0.5.7",
  },
  {
    :name    => "vagrant-vbguest",
    :version => ">= 0.15.1",
  },
]
plugins.each do |plugin|
  if not Vagrant.has_plugin?(plugin[:name], plugin[:version])
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin plugin
  end
end
$bootstrap = <<SCRIPT
echo Self provisioning...
apt-get update -y && \
apt-get install python-apt python-minimal -y
SCRIPT
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", "1024"]
    # http://www.virtualbox.org/manual/ch09.html#nat-adv-dns
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.memory = 2048
    vb.cpus = 2
    vb.linked_clone = true
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
    v.vm.hostname = "quartermaster.dev"
    v.vm.network "private_network", ip: "192.168.33.42"
  end

  config.vm.define "dev-te01" do |v|
    v.vm.hostname = "dev-te01.dev"
    v.vm.network "private_network", ip: "192.168.33.43"
  end

  config.vm.define "observium" do |v|
    v.vm.hostname = "observium" + DOMAIN
    v.vm.provision "shell", inline: $bootstrap
#    v.vm.provision "shell", inline: $observium
    v.vm.provision "puppet" do | puppet |
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "default.pp"
    end
    v.vm.network "private_network", ip: "192.168.0.11"
  end

end
