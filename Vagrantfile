# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  config.vm.define "acs" do |acs|
    acs.vm.box = "ubuntu/trusty64"
    acs.vm.hostname = "acs"
    acs.vm.network "private_network", ip: "192.168.33.10"
  end

  config.vm.define "web" do |web|
    web.vm.box = "nrel/CentOS-6.7-x86_64"
    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "192.168.33.20"
    web.vm.network "forwarded_port", guest: 80, host: 8080
  end

  config.vm.define "db" do |db|
    db.vm.box = "nrel/CentOS-6.7-x86_64"
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.33.30"
  end

  config.vm.define "nagioscore" do |v|
    v.vm.box = "binbashing/centos7-x64-nagios-4"
    v.vm.hostname = "v"
    v.vm.network "private_network", ip: "192.168.33.40"
    v.vm.network "forwarded_port", guest: 80, host: 8082
  end

  config.vm.provider "virtualbox" do |puppetmaster|
    puppetmaster.customize ["modifyvm", :id, "--memory", "4096"]
  end

  config.vm.define "puppetmaster" do |puppetmaster|
    puppetmaster.vm.box = "ubuntu/xenial64"
    puppetmaster.vm.hostname = "puppetmaster"
    puppetmaster.vm.network "private_network", ip: "192.168.33.41"
  end

    config.vm.define "quartermaster" do |v|
    v.vm.box = "ubuntu/xenial64"
    v.vm.hostname = "quartermaster"
    v.vm.network "private_network", ip: "192.168.33.42"
  end

end
