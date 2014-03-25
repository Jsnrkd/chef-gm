---
layout: page
title:  Provisioning Rackspace
lead:   Chef-solo on Rackspace
---


**Goal:** Provision a server on Rackspace using an existing chef-solo project.

**Audience:** Sysadmins and developers with CLI experience and general Chef knowledge.

**Dependencies:** ruby, python ~> 2.6 git, chef, knife-solo

**Optional:** [bundler](http://bundler.io/)

*Tested on OSX 10.9.2*

As of 3/2014, the [knife rackspace plugin](https://github.com/opscode/knife-rackspace) doesn't support chef solo so if you want do it programmatically, you can use the REST api or the Openstack Nova client. Otherwise use the rackspace.com server creation GUI.  We will use the Nova client on the CLI for this tutorial.

#Configure Working Environment

##Install [Nova](http://docs.rackspace.com/servers/api/v2/cs-gettingstarted/content/section_gs_install_nova.html)

[Nova](http://docs.rackspace.com/servers/api/v2/cs-gettingstarted/content/section_gs_install_nova.html) is an opensource CLI utility written in python for interacting with [openstack](http://openstack.org) providers.  It wraps the API for ease of use so you don't need to write cURL commands.  It is installed using the python package manager [pip](https://pypi.python.org/pypi/pip).  Openstack and Nova began as a Rackspace initiative.

    $ sudo easy_install pip
    $ sudo easy_install -U setuptools
    $ sudo pip install rackspace-novaclient

##Authenticate

We must configure our credentials to tell Rackspace who we are.  The Nova client can be configured with your Rackspace credentials to make provisioning simpler.  Set these environment variables for connecting to rackspace in your `.bash_profile` for convenience. 

	$ nano ~./bash_profile

Add the following to the end of your bash_profile. 

	export OS_AUTH_URL=https://identity.api.rackspacecloud.com/v2.0/
	export OS_AUTH_SYSTEM=rackspace
	export OS_REGION_NAME=DFW
	export OS_USERNAME=<username>
	export OS_TENANT_NAME=<tenant_id>
	export NOVA_RAX_AUTH=1
	export OS_PASSWORD=<api_key>
	export OS_PROJECT_ID=<tenant_id>
	export OS_NO_CACHE=1

- `<username>` is your Rackspace username
- `<tenant_id>` is your Rackspace account id found in the website header by logging into [rackspace.com](http://rackspace.com).
- `<api_key>` is listed under account management.

You must restart your terminal or type `$ source ~/.bash_profile` for the changes to take affect.

You are now ready to authenticate.  The Nova authentication token is only valid for 24 hours so you upon interacting with the client you must issue the following command

    $ nova credentials

The authentication token will be automatically set for you and remain valid for 24 hours.  [Details](http://docs.rackspace.com/servers/api/v2/cs-gettingstarted/content/nova_auth.html).

##Configure SSH Keys

For chef to run on the new machine you need to configure a SSH key pair.  These can be configured while you are logged into rackspace.com or you can use the Nova client.  To conveniently create and automatically upload a new public key to your Rackspace account, run:

    $ nova keypair-add name_of_key_pair > ~/.ssh/rackspace_key.pem

- `name_of_key_pair` will be what you use to identify it through the terminal and under key management on Rackspace.com.  I recommend picking something simple and identifiable.
- The key will be stored with your other ssh keys in the previous command.
- Now you can ssh into the new machine without typing a password manually when you specify it in the boot action below.

The key needs proper permissions to be used as a SSH key pair so we need to update them:

    $ chmod 600 ~/.ssh/rackspace_key.pem

(Additional Help)[http://www.rackspace.com/knowledge_center/article/manage-ssh-keypairs-for-cloud-servers-with-python-novaclient]

##Install Gems 

Install the [Chef](http://docs.opscode.com/install_workstation.html) related gems.  If you use [bundler](http://bundler.io/), run `$ bundle install` from the project directory. Otherwise

    $ gem install chef --no-ri --no-rdoc
    $ gem install knife-solo --no-ri --no-rdoc


#Gather Parameters

Using the Nova client, you can, among many things, create servers through the CLI.  You'll need to know a few parameters before you do though.  Take note the ids that print with the following commands.

###Flavors

Flavors correspond to machine sizes on Rackspace.  You can read more about their features and pricing on [Rackspace.com](http://www.rackspace.com/cloud/servers/).  This decision initially dictate your server costs so choose appropriately.

    $ nova flavor-list

###Images

To see which base operating systems are available, run:

    $ nova image-list

#Create Server

Now that we have all the parameters we need, we can create a server.  Here's an example booting a basic 512MB Ubuntu 12.04 server with my previously generate keypair.

    $ nova boot mytestserver --flavor 2 --image 0fb5a76c-8488-42b5-94f3-65e57b725813 --key-name name_of_key_pair

After running this command, it will take a few minutes for the server to come online.  You can check the status by running `$ nova list` or more specifically `$ nova show {server id}`.  Once the server is **active**, you can begin provisioning it with chef.


#Define a Node

Now we need install Chef on the server. 

    $ knife solo prepare root@{server-ip} -i ~/.ssh/rackspace_key.pem

Once this command completes, we need to configure the new [node](http://docs.opscode.com/essentials_node_object.html).  The previous `prepare` command created a file called `nodes/{server-ip}.json`.  This file will essentially define how the node with be provisioned.  Edit this file to look similar to

    {
        "run_list": ["recipe[name_of_recipe]"],
        "environment": "development"
    }

For more settings, consult the Opscode [node documentation](http://docs.opscode.com/essentials_node_object.html).

#Provision

Provisioning will bring the node to an idempotent state. You use this to initially run your recipes and to update the server to the latest state.

    $ knife solo cook root@{server-ip} -i ~/.ssh/rackspace_key.pem 

If you have root login enabled, you will be able to ssh in with `ssh root@{server-ip} -i ~/.ssh/rackspace_key.pem`
#Update Server

Updating the server involves making changes to your recipes and then updating with the previous command in the provisioning section.
