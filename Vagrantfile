# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
  # config.vm.box = "geerlingguy/centos7"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provider "virtualbox" do |v|
#    v.memory = 256
#    v.cpus = 1
    v.customize ["modifyvm", :id, "--memory", "256"]
    v.linked_clone = true
    end

  # lab
  config.vm.define "acs" do |v|
    v.vm.hostname = "acs"
    v.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "web" do |v|
    v.vm.box = "nrel/CentOS-6.7-x86_64"
    v.vm.hostname = "web"
    v.vm.network "private_network", ip: "192.168.33.20"
    v.vm.network "forwarded_port", guest: 80, host: 8080
  end

  config.vm.define "db" do |v|
    v.vm.box = "nrel/CentOS-6.7-x86_64"
    v.vm.hostname = "db"
    v.vm.network "private_network", ip: "192.168.33.30"
  end

  config.vm.define "nagios" do |v|
    v.vm.hostname = "nagios.dev"
    v.vm.network "private_network", ip: "192.168.33.13"
  end

  config.vm.define "puppetmaster" do |v|
    v.vm.hostname = "puppetmaster"
    v.vm.network "private_network", ip: "192.168.33.41"
  end

  config.vm.define "quartermaster" do |v|
    v.vm.hostname = "quartermaster"
    v.vm.network "private_network", ip: "192.168.33.42"
  end

end
