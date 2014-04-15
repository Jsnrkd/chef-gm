#
# Cookbook Name:: app
# Recipe:: default
#
# Copyright (C) 2014 Jason Rikard
# 
# All rights reserved - Do Not Redistribute
#


include_recipe "apt"
include_recipe "unattended-upgrades"
include_recipe "ntp"
include_recipe "openssh"
include_recipe "sudo"

swap_file '/mnt/swap' do
  size      node['server']['swap']['size']  
end

#include_recipe "s3_file"


#s3cmd recipe uses an ohai user resource that isn't available on the first run unless you 
#reload it after user creation.
# ohai "reload_passwd" do
#   action :nothing
#   plugin "passwd"
# end

#create and configure the single user
group node['server']['group']

user node['server']['user'] do
  supports :manage_home => true
  group node['server']['group']
  system false
  shell '/bin/bash'
  home "/home/#{node['server']['user']}"
  password '$1$ml.LUbgD$hPRLXa2lz.x0.LXVl3YiH1'
  action :create
  # notifies :create, resources(:ohai => "reload_passwd"), :immediately
end

directory "/home/deploy/.ssh/" do
  owner node['server']['user']
  action :create
  recursive true
end

file '/home/deploy/.ssh/authorized_keys' do
	action :delete
end

# create their ssh key
node['server']['authorized_keys'].each do |a_key|
	execute 'add authorized_keys' do
	  user 'deploy'
	  command "echo #{a_key} >> /home/deploy/.ssh/authorized_keys"
	end
end


include_recipe 'app::packages'
include_recipe 'app::apache'
include_recipe 'ufw'
include_recipe 'fail2ban'
include_recipe 'chef-s3cmd2'
include_recipe 'app::bb_deploy_user'
include_recipe 'app::mysql'

#define helper aliases
magic_shell_alias node['app']['name'] do
  command "cd #{node['app']['app_root']}"
end

#todo make webserver agnostic
magic_shell_alias 'sites' do
  command "cd /etc/apache2/sites-available"
end

magic_shell_alias 'www' do
  command 'cd /srv/www'
end



