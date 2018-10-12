# -*- mode: ruby -*-
# vi: set ft=ruby :
DOMAIN = '.dev'
boxes =[
  {
    :name => "ldap1",
    :eth1 => "192.168.4.10",
    :mac1 => "000c295526f9",
    :mem  => "2048",
    :cpu  => "2",
  },
  {
    :name => "splunk",
    :eth1 => "192.168.4.11",
    :mac1 => "000c295526f0",
    :mem  => "2048",
    :cpu  => "2",
  },
  {
    :name => "pve1",
    :eth1 => "192.168.4.12",
    :mac1 => "000c29000412",
    :mem  => "2048",
    :cpu  => "2",
  },
  {
    :name => "pve2",
    :eth1 => "192.168.4.13",
    :mac1 => "000c29000413",
    :mem  => "2048",
    :cpu  => "2",
  },
  {
    :name => "librenms",
    :eth1 => "192.168.4.14",
    :mac1 => "000c29000414",
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
    vb.memory = 1024
    vb.cpus = 2
    vb.linked_clone = true
  end

  boxes.each do |opts|
    config.vm.define opts[:name] do |config|
      config.vm.hostname = opts[:name] + DOMAIN
      config.vm.network :private_network, ip: opts[:eth1]
      config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--macaddress1", opts[:mac1]]
        vb.memory = opts[:mem]
        vb.cpus = opts[:cpu]
      end
    end
  end

  config.vm.define "observium" do |v|
    v.vm.hostname = "observium" + DOMAIN
    v.puppet_install.puppet_version = '5.4.0'
    v.vm.provision "puppet" do | puppet |
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path    = "puppet/modules"
    end
    v.vm.provision "shell", inline: 'curl \
    -o /home/docker/observium/docker-compose.yml\
    https://raw.githubusercontent.com/penguin02007/vagrant/master/docker-compose.observium.yml\
    2> /dev/null
    docker-compose -f /home/docker/observium/docker-compose.yml up -d'
    v.vm.network "private_network", ip: "192.168.4.9"
  end

  config.vm.define "ldap1" do |v|
    v.puppet_install.puppet_version = '5.4.0'
    v.vm.provision "puppet" do | puppet |
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path    = "puppet/modules"
    end
    v.vm.provision "shell", inline: 'curl \
    -o /tmp/docker-compose.ldap.yml \
    https://raw.githubusercontent.com/penguin02007/vagrant/master/docker-compose.ldap.yml\
    2> /dev/null
    docker-compose -f /tmp/docker-compose.ldap.yml up -d'
  end

  config.vm.define "splunk" do |v|
    v.vm.provision "shell", inline: "if \
    [ ! -d \'/opt/splunk\' ]; then \
    wget -O /tmp/splunk-7.1.1-8f0ead9ec3db-linux-2.6-amd64.deb 'https://www.splunk.com/bin/splunk/DownloadActivityServlet?architecture=x86_64&platform=linux&version=7.1.1&product=splunk&filename=splunk-7.1.1-8f0ead9ec3db-linux-2.6-amd64.deb&wget=true' && dpkg -i /tmp/splunk-7.1.1-8f0ead9ec3db-linux-2.6-amd64.deb && /opt/splunk/bin/splunk start --accept-license --answer-yes --seed-passwd changeme && /opt/splunk/bin/splunk enable boot-start; \
    fi"
    v.puppet_install.puppet_version = '5.4.0'
    v.vm.provision "puppet" do | puppet |
      puppet.manifests_path = "puppet/manifests"
      puppet.module_path    = "puppet/modules"
      puppet.options        = "--verbose --show_diff"
    end
  end

  config.vm.define "ansible" do |v|
    v.vm.box = "ubuntu/bionic64"
    v.vm.hostname = "ansible" + DOMAIN
    v.vm.network "public_network", ip: "192.168.4.15"
  end

end
