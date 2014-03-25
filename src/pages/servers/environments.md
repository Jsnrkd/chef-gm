---
layout: page
title:  Chef Solo Environments
lead:   Iterating with chef-solo
---



#Environments

Environments in chef are where you can override attributes that make provisining development, staging and production servers different. For example, you probably want most debugging options enabled in development but not in production.  The knife command `$ knife environment create` doesn't support Chef solo so we must create our own environment files. If you want to create a custom environment, place the following snippet for customization in `{repo_directory}/environments/{your_environment}.json`.

    {
	    "name": "development",
	    "description": "This environment describes a local development environment using Vagrant",
	    "json_class": "Chef::Environment",
	    "chef_type": "environment",
	    "default_attributes": {
	    	"example_attribute_to_override": "true"
	    },
	    "override_attributes": {
	    	"example_attribute_to_override": "true"
	    }
    }


Notice that you have two options: `default_attributes` and `override_attributes`.  You should start by specifying your custom attributes in the default_attributes object because override_attributes is pretty high on the [precedence list](http://docs.opscode.com/essentials_cookbook_attribute_files.html).  This advice may help keep your attribute inheritance easier to manage in the future.  If you need some assurance that your attributes will be adhered to, place them in the `ovverride_attributes` object.

####What Attributes can I choose from?
A good place to find the default attributes is `{cookbooks_dir}/{cookbook_name}/attributes/default.rb`.  To find more options, check in other cookbook directories for for default attribute files as well.

####Environments with Vagrant
    
Not all environments will be provisioned with Vagrant since they will be provisioned remotely after development.  Sometimes there are settings that should only apply to during Vagrant sessions.  For example, you may need to change a port or password that would be otherwise unsecure on a public server. Luckily, you can specify attributes in the `Vagrantfile` that augment your attributes defined in your  environment.  They will not, however, take precedence over any attributes defined in the `override_attributes` object.

In your `Vagrantfile` you can specify additional json as so:

    config.vm.provision :chef_solo do |chef|
	    chef.environments_path = 'environments'
	    chef.environment = 'development'
	    chef.json = {
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
	end

