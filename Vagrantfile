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
		dev.vm.box_download_insecure = "jesperwermuth/Ubuntu-14-04-Headless"
		dev.vm.box = "jesperwermuth/Ubuntu-14-04-Headless"
		dev.vm.box_url = "https://atlas.hashicorp.com/jesperwermuth/Ubuntu-14-04-Headless"
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
		#config.vm.network "forwarded_port", guest: 4243, host: 4243
		#config.vm.network "forwarded_port", guest: 8080, host: 9
	end

	([MACHINE_NAME]).each do |setup_dev_env|
		config.vm.define "#{setup_dev_env}" do |machine|
		    machine.vm.network "public_network", bridge: 'wlan0'
		
			# Latest Docker
			machine.vm.provision "shell", path: "docker.sh"
			machine.vm.provision "shell", path: "docker-compose.sh"
		end 
	end
end
