# -*- mode: ruby -*-
# vi: set ft=ruby :

#### USER PARAMETERIZE ##############################################################
# This section allows you to parametrize the vagrant build process.


if ENV['MACHINE'].nil?
	MACHINE = "default"
else
    MACHINE = ENV['MACHINE']
end 

BOX_NAME="jesperwermuth/Ubuntu-14-04-Top-Dockerhost"

#####################################################################################

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.define MACHINE do |config|
	    config.vm.provider :virtualbox do |vb|
			vb.gui = false
			#vb.name = 'TopDockerHost'
			vb.customize ["modifyvm", :id, "--memory", "2048"]
			vb.customize ["modifyvm", :id, "--cpus", "2"]
			vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
			vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
			vb.customize ["modifyvm", :id, "--ioapic", "on"]
			vb.customize ["modifyvm", :id, "--vram", "128"]
			vb.customize ["modifyvm", :id, "--hwvirtex", "on"] 
		end

        #puts "Machine name is [#{MACHINE_NAME}]"
	 	# box_download_insecure is a hack to cover up for curl certificate error. See https://github.com/jeroenjanssens/data-science-at-the-command-line/issues/29
		config.vm.box = BOX_NAME
		config.vm.box_download_insecure = BOX_NAME
		config.vm.hostname = MACHINE
		config.vm.box_url = "https://atlas.hashicorp.com/" + BOX_NAME
        config.vm.provision "shell", path:  "docker-configure.sh"
        config.vm.provision "shell", inline: "sudo service docker restart && sleep 3"
		config.vm.network "private_network", ip: "192.168.33.10"

		# The ports are forwarded 'as is' by default.
    end
end
