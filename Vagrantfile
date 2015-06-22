# -*- mode: ruby -*-
# vi: set ft=ruby :

#### USER PARAMETERIZE ##############################################################
# This section allows you to parametrize the vagrant build process.

# When you push to a repo, this is the user that will be used

if ENV['MACHINE'].nil?
	MACHINE_NAME = "anonymous"
else
    MACHINE_NAME = ENV['MACHINE']
end 

BOX_NAME="jesperwermuth/Ubuntu-14-04-Top-Dockerhost"
# USER on Linux
# USERNAME on Windows

#####################################################################################

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


## TODO 
# -H=unix:///var/run/docker.sock -H=0.0.0.0:4243 
# should be automaticall configured...

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.define MACHINE_NAME do |dev|
        puts "Machine name is [#{MACHINE_NAME}]"
	 	# box_download_insecure is a hack to cover up for curl certificate error. See https://github.com/jeroenjanssens/data-science-at-the-command-line/issues/29
		dev.vm.box_download_insecure = BOX_NAME
		dev.vm.box = BOX_NAME
		dev.vm.box_url = "https://atlas.hashicorp.com/" + BOX_NAME
	    dev.vm.provider :virtualbox do |vb|
			vb.gui = false
			vb.customize ["modifyvm", :id, "--memory", "2048"]
			vb.customize ["modifyvm", :id, "--cpus", "2"]
			vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
			vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
			vb.customize ["modifyvm", :id, "--ioapic", "on"]
			vb.customize ["modifyvm", :id, "--vram", "128"]
			vb.customize ["modifyvm", :id, "--hwvirtex", "on"] 
		end
		# The ports are forwarded 'as is' by default.
	end

	([MACHINE_NAME]).each do |setup_dev_env|
		config.vm.define "#{setup_dev_env}" do |machine|
		    machine.vm.network "public_network", bridge: 'wlan0'
		
			# Latest Docker (not needed anymore, already in Ubuntu-14-04-Top-Dockerhost image)
			#machine.vm.provision "shell", path: "docker.sh"
			# Allow anyone to connect to docker host and allow usage of an unsecure-registry
			config.vm.provision "shell", inline: "sudo echo DOCKER_OPTS=\"-H=unix:///var/run/docker.sock -H=0.0.0.0:4243 --insecure-registry 192.168.1.24:5000\" >> /etc/default/docker"
			# Restart docker to re-read /etc/default/docker file
			config.vm.provision "shell", inline: "sudo service docker restart && sleep 3"
		end 
	end
end
