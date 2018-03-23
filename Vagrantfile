# -*- mode: ruby -*-
# vi: set ft=ruby :
DOMAIN = '.dev'
boxes =[
  {
    :name => "ldap1",
    :eth1 => "192.168.33.11",
    :mac1 => "000c295526f9",
    :mem  => "2048",
    :cpu  => "2",
  },
]
plugins = [
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

  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name] + DOMAIN
      config.vm.network :private_network, ip: opts[:eth1]
      config.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", opts[:mem]]
        v.customize ["modifyvm", :id, "--cpus", opts[:cpu]]
        v.customize ["modifyvm", :id, "--macaddress1", opts[:mac1]]
      end
    end
  end

  config.vm.define "observium" do |v|
    v.vm.hostname = "observium" + DOMAIN
    v.puppet_install.puppet_version = '5.4.0'
    v.vm.provision "puppet" do | puppet |
      puppet.manifests_path = "manifests"
      puppet.manifest_file  = "default.pp"
      puppet.manifest_file  = "observium.pp"
      puppet.options        = "--verbose"
    end
    v.vm.provision "shell", inline: 'curl \
    -o /home/docker/observium/docker-compose.yml\
    https://raw.githubusercontent.com/penguin02007/vagrant/master/docker-compose.yml\
    2> /dev/null
    docker-compose -f /home/docker/observium/docker-compose.yml up -d'
    v.vm.network "private_network", ip: "192.168.33.11"
  end

end
