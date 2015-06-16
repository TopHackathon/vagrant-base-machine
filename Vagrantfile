# -*- mode: ruby -*-
# vi: set ft=ruby :

#### USER PARAMETERIZE ##############################################################
# This section allows you to parametrize the vagrant build process.

# When you push to a repo, this is the user that will be used
DEVELOPER_ID = ENV['USER']
# USER on Linux
# USERNAME on Windows

if DEVELOPER_ID.empty?
	DEVELOPER_ID = "anonymous"
end 

puts "Developer id is [#{DEVELOPER_ID}]"

#####################################################################################

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.define "dev" do |dev|
	 	# box_download_insecure is a hack to cover up for curl certificate error. See https://github.com/jeroenjanssens/data-science-at-the-command-line/issues/29
		dev.vm.box_download_insecure = "jesperwermuth/Ubuntu-14-04-Desktop"
		dev.vm.box = "jesperwermuth/Ubuntu-14-04-Desktop"
		dev.vm.box_url = "https://atlas.hashicorp.com/jesperwermuth/boxes/Ubuntu-14-04-Desktop"
	    dev.vm.provider :virtualbox do |vb|
			vb.gui = true
			vb.customize ["modifyvm", :id, "--memory", "2048"]
			vb.customize ["modifyvm", :id, "--cpus", "2"]
			vb.customize ["modifyvm", :id, "--graphicscontroller", "vboxvga"]
			vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
			vb.customize ["modifyvm", :id, "--ioapic", "on"]
			vb.customize ["modifyvm", :id, "--vram", "128"]
			vb.customize ["modifyvm", :id, "--hwvirtex", "on"] 
		end
	end

	(["dev"]).each do |setup_dev_env|
		config.vm.define "#{setup_dev_env}" do |machine|
		
		    machine.vm.network "public_network"
		
			machine.vm.provision "shell", inline: "sudo apt-get install puppet -y"
			machine.vm.provision :puppet do |puppet|
				puppet.facter = {
				      "developer" => DEVELOPER_ID,
				    }		
				puppet.manifests_path = "manifests"
				puppet.module_path = "modules"
				puppet.manifest_file = "init.pp"
				end

			# Update software package locations
			# machine.vm.provision "shell", inline: "sudo apt-get update --fix-missing -y"
			# Upgrade to latest version of software packages
			# machine.vm.provision "shell", inline: "sudo apt-get upgrade -y"
		
			# vagrant in specific version
			machine.vm.provision "shell", path: "vagrant.sh"

			machine.vm.provision "shell", inline: "sudo apt-get install virtualbox -y"

			# Latest Docker
			machine.vm.provision "shell", path: "docker.sh", args:[DEVELOPER_ID]
			machine.vm.provision "shell", path: "docker-compose.sh"

			# Development environment
			machine.vm.provision "shell", path: "java.sh"
			# installing jenkins requires git
			machine.vm.provision "shell", path: "git.sh"
			# I use gradle as build tool
			machine.vm.provision "shell", path: "gradle.sh"
		end 
	end
end
