# -*- mode: ruby -*-
# vi: set ft=ruby :

# General project settings
#################################

  # IP Address for the host only network, change it to anything you like
  # but please keep it within the IPv4 private network range
  ip_address = "172.22.22.76"

  # The project name is base for directories, hostname and alike
  project_name = "example"



Vagrant.configure("2") do |config|
      # Enable Berkshelf support
    config.berkshelf.enabled = true

    config.omnibus.chef_version = "11.10.4"

    # Define VM box to use
    config.vm.box = "precise64"
    config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    # Set share folder
    config.vm.synced_folder "../" , "/srv/www/" + project_name + "/", :mount_options => ["dmode=777", "fmode=666"]

    # Use hostonly network with a static IP Address and enable
    # hostmanager so we can have a custom domain for the server
    # by modifying the host machines hosts file
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.vm.define project_name do |node|
      node.vm.hostname = project_name + ".dev"
      node.vm.network :private_network, ip: ip_address
      node.hostmanager.aliases = [ "www." + project_name + ".dev" ]
    end
    config.vm.provision :hostmanager

  config.vm.provision :chef_solo do |chef|
    chef.environments_path = 'environments'
    chef.environment = 'development'
    chef.json = {
        "app" => {
          "app_root" => '/srv/www/example',
          "document_root" => '/srv/www/example/httpdocs'
        },
        "authorization" => {
          "sudo" => {
              "users" => [ "vagrant" ],
              "passwordless" => true,
          }
        },
        'openssh' => {
          'server' => {
            'password_authentication' => 'yes'
          }
        }
      }

    chef.run_list = [
        "recipe[app]"
    ]
  end
end
