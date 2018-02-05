Vagrant.configure("2") do |config|
  #  http://www.lucainvernizzi.net/blog/2014/12/03/vagrant-and-libvirt-kvm-qemu-setting-up-boxes-the-easy-way/
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", "256"]
    v.linked_clone = true
  config.vm.provision "shell", inline: $bootstrip
  config.vm.box = "ubuntu/xenial64"
  end

 config.vm.provider :libvirt do |libvirt|
    libvirt.host = 'libvirthost'
    libvirt.username = 'root'
    libvirt.connect_via_ssh = true
  end

  config.vm.synced_folder ".", "/vagrant", disabled: true
# bootstrip
$bootstrip = <<SCRIPT
echo Self provisioning...
apt-get update -y && \
apt-get install python-apt python-minimal -y
SCRIPT

# nat config
def nat(config)
    config.vm.provider "libvirt" do |v|
      v.customize ["modifyvm", :id, "--nic1", "natnetwork", "--nat-network2", "pxe", "--nictype1", "virtio"]
    end
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
