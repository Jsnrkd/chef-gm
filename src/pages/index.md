---
layout: page
title:  YLIapps Overview
lead:   Documentation for YLIapps
---

Welcome to the documentation for all that is YLIapps. This is where you will find workflows and protocols for development of YLI projects.

# Target Deployment Environment

- Ubuntu 12.04 Precise 64bit
- Apache 2.2
- MySQL 5.5
- PHP 5.4
- ?Redis?
- ?Memcache?

# Application Description

- Laravel 4.1
- ...

# Development Environment

The next steps will guide you through an automated development environment that has been configured using Vagrant and Chef-Solo to run in an Ubuntu virtual machine closely matching production.  When you are finished, your development environment will have high parity with production and other developers' environments.  You should also be able to get up and ready to develop in about an hour of beginning this tutorial.

###Dependencies
- Ruby 2.x >= ([RVM](https://rvm.io/) recommended) 
    - (Gems: Capistrano 3.x >=, berkshelf 3.x >= )
- [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](http://vagrantup.com) 1.4.x >= 
    - Plugins: [vagrant-berkshelf](https://github.com/berkshelf/vagrant-berkshelf), [vagrant-hostmanager](https://github.com/smdahlen/vagrant-hostmanager)
- git 1.8.x >=

###Conifigure SSH Keys

Configure your public/private key pair in your BitBucket account.

###Install Dependencies

The following applies to OSX 10.9 >=

#####OSX Developer Tools

    # Ensure OSX developer tools are installed
    $ xcode-select --install

#####Ruby
Ruby is required and [RVM](https://rvm.io/) is the recommended way of managing your versions and gems.

    # Install RVM
    $ \curl -sSL https://get.rvm.io | bash -s stable
    $ rvm use 2.1.0 --default

Configure RVM if necessary.

#####Gems
//todo use bundler instead
[Berkshelf](http://berkshelf.com) - Chef cookbook dependency manager
[Capistrano](http://capistranorb.com/documentation/getting-started/installation/) - Application Deployment

    $ gem install berkshelf --no-ri --no-rdoc
    # If this hangs, kill the process and rerun the command.

    $ gem install capistrano  --no-ri --no-rdoc

#####Vagrant Plugins

    $ vagrant plugin install vagrant-hostmanager
    $ vagrant plugin install vagrant-berkshelf

###Provision Virtual Machine

You must have installed all depencies from the previous section for these commands to complete.

    $ git clone --recursive git@bitbucket.org:MrRoboto/books.git
    $ cd {project_directory}/books-chef
    $ vagrant up

Provisioning for the first time can take 3-15 minutes depending on your internet connection speed.  You may be prompted for your local user password to edit the hosts file.
  
If the books-chef directory is empty, pull the books-chef git submodule from the top of the working directory.

    $ git submodule update --init --recursive

###Run Composer
Third party libraries are managed with [Composer](https://getcomposer.org/) and aren't stored in the application repo so you must install them.

    # from vagrant ssh and cd /var/www/books
    $ composer install

###Provision and Seed Database

    # from vagrant ssh and cd /var/www/books
    $ php artisan migrate
    $ php artisan db:seed


###MySQL Details

**MySQL Host:** 172.22.22.22,
**User:** Root,
**Password:** Root,
**Port:** 3306

###SSH Details
**Host:** 172.22.22.22,
**User:** vagrant,
**Password:** vagrant


##Dev Environment Conclusion

- App is now available at books.dev, www.books.dev and 172.22.22.22
- Default App user is jmayhak@gmail.com password: P@ssw0rd!

# Database Setup
 
### Migrate Schema
Migrates the database schema to latest migration.  Migrations are available through [Artisan](http://laravel.com/docs/artisan). 

    $ cd /var/www/books
    $ php artisan migrate

###Seed Database
Dummy data is generated with [Faker](https://github.com/fzaninotto/Faker). 

    $ cd /var/www/books
    $ php artisan db:seed


# Application Deployment

[Capistrano](http://capistranorb.com/) is used for application deployment.

1. Configure SSH keys with the target server and the repository.


###Deploy

    $ cd {project_directory}
    $ cap {staging, production} deploy


###Rollback


#Server Provisioning

##Install Packages [Chef](http://docs.opscode.com/install_workstation.html)
//bundler
    $ gem install chef --no-ri --no-rdoc
    $ gem install knife-solo --no-ri --no-rdoc
    $ gem install foodcritic --no-ri --no-rdoc
    $ gem install knife-digital_ocean --no-ri --no-rdoc

Configure SSH keys on digital ocean

[Knife-digital_ocean docs](https://github.com/rmoriz/knife-digital_ocean)
[Knife-solo berkshelf integration doc](https://github.com/matschaffer/knife-solo/wiki/Berkshelf-&-Librarian-Chef-integration)

Configure ~/.chef/knife.rb or {project_directory}/books-chef/.chef/knife.rb

Check that these settings are in the config

    knife[:digital_ocean_client_id] = 'your_client_id'
    knife[:digital_ocean_api_key] = 'your_api_key'

Ensure you are configured correctly

    cd ~/chef-repo
    knife digital_ocean droplet list

Provision

    $ knife digital_ocean droplet create -N books-prod --ssh-keys 87619 --image 1505447 --location 1 --size 66 --solo

Update server config
    $ knife solo cook root@192.241.138.212 nodes/books-prod.json

#####Things to define

###Debugging

###Profiling

###Committing (git Workflow)

###Back End Patterns

###Front End Patterns

###Bug Tracking

###Task Tracking

###QA

###Testing

###Monitoring

###Documenting

###Dev Tools

###Communication
####Contact Info
####Meetings

###Disaster Recovery

###User Management

###Responsibilities


#Links
[Php The Right Way](http://phptherightway.com/)
[Digital Ocean](https://www.digitalocean.com/community/)