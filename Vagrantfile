# Usage : 
#	vagrant up - starts the default machine "tie"
# 	MACHINE=someId up : starts machine someId
#   MACHINE=someId halt : stops machine someId
#   etc. etc.

#TODO upload image with pull to Atlas *for better performance*
#TODO usage message
#TODO import Jons stuff
#TODO make callable in a more reproducable way
#TODO setup registry locally
#TODO initialize registry with our own dockerfiles

# -*- mode: ruby -*-
# vi: set ft=ruby :

#### USER PARAMETERIZE ##############################################################
# This section allows you to parametrize the vagrant build process.


if ENV['MACHINE'].nil?
	MACHINE = "tie"
else
    MACHINE = ENV['MACHINE']
end 

BOX_NAME="jesperwermuth/Ubuntu-14-04-Top-Dockerhost"

#####################################################################################

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    #puts "Machine name is [#{MACHINE}]"
 	# box_download_insecure is a hack to cover up for curl certificate error. See https://github.com/jeroenjanssens/data-science-at-the-command-line/issues/29
	config.vm.box = BOX_NAME
	config.vm.box_download_insecure = BOX_NAME
	config.vm.hostname = MACHINE
	config.vm.box_url = "https://atlas.hashicorp.com/" + BOX_NAME
    config.vm.provision "shell", path:  "docker-configure.sh"
    config.vm.provision "shell", inline: "sudo service docker restart && sleep 3"
	config.vm.network "private_network", ip: "192.168.33.10"


    config.vm.define MACHINE do |config|
	    config.vm.provider :virtualbox do |vb|
			vb.gui = false
			# Further options: http://www.virtualbox.org/manual/ch08.html#vboxmanage-modifyvm
			vb.customize ["modifyvm", :id, "--memory", "2048"]
			vb.customize ["modifyvm", :id, "--cpus", "2"]
			vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
			vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
			vb.customize ["modifyvm", :id, "--ioapic", "on"]
			vb.customize ["modifyvm", :id, "--vram", "128"]
			vb.customize ["modifyvm", :id, "--hwvirtex", "on"] 
			vb.customize ["modifyvm", :id, "--nictype1", "virtio"] 
		end
		
		# Automatically use local apt-cacher-ng if available
		if File.exists? "/etc/apt-cacher-ng"
		require 'socket'
		guessed_address = Socket.ip_address_list.detect{|intf| !intf.ipv4_loopback?}
		    if guessed_address 
		      config.vm.provision :shell, :inline => "echo 'Acquire::http { Proxy \"http://#{guessed_address.ip_address}:3142\"; };' > /etc/apt/apt.conf.d/00proxy"
		    end
		end
		# The ports are forwarded 'as is' by default.
    end
    

    
#    # run with vagrant up registry --provider="docker"
#    config.vm.define "registry" do |a|
#    # docker run -p 5000:5000 -v /var/dockerregistry/:/tmp/registry-dev registry
#    a.autostart = false
#    a.vm.provider "docker" do |d|
#      d.image = "registry"
#      d.build_args = ["-t=registry"]
#      d.ports = ["5000:5000"]
#      d.name = "registry"
#      d.remains_running = true
#      d.volumes = ["/myregistrydata:/var/lib/registry"]
#    end
#  end
  
end
