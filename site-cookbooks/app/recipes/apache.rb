#
# Cookbook Name:: app
# Recipe:: apache
#
# Copyright (C) 2014 Jason Rikard
# 
# All rights reserved - Do Not Redistribute
#


include_recipe "dotdeb"


include_recipe "apt"

#setup apache 
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_expires"
include_recipe "apache2::mod_auth_basic"

include_recipe "dotdeb::php54"
include_recipe "php"

#include_recipe "apache2::mod_env"

remote_file "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb" do
  source 'https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb'
  mode '0644'
  action :create_if_missing
end

# create document root
directory node['app']['app_root'] do
  owner 'deploy'
  group 'deploy'
  action :create
  recursive true
end

#Fixes capistrano permissions
directory "#{node['app']['app_root']}/current" do
  owner 'deploy'
  group 'deploy'
  action :create
  recursive true
end

directory node['app']['document_root'] do
  owner 'deploy'
  group 'deploy'
  action :create
  recursive true
end

#include_recipe "apache2::mod_pagespeed"
dpkg_package 'mod_pagespeed' do
  source "#{Chef::Config[:file_cache_path]}/mod-pagespeed.deb"
  action :install
end

apache_module 'pagespeed' do
  conf true
end

# disable default site
apache_site '000-default' do
  enable false
end

web_app node['app']['name'] do
  server_name node['app']['fqdn']
  server_aliases ["www.#{node['app']['fqdn']}"]
  docroot node['app']['document_root']
  cookbook 'app'
  template 'apache2.conf.erb'
end


# Install PHP5 packages
node['app']['php_packages'].each do |a_package|
  package a_package
end

package "apache2" do
  action :upgrade
end

package "php5" do
  action :upgrade
  notifies :restart, 'service[apache2]'
end

#not compatible atm
# php_pear "zendopcache" do
#   action :install
#   preferred_state "beta"
# end

#Configure APC opcode cache

directory '/etc/apc/' do
  owner 'root'
  group 'root'
  action :create
end

file '/etc/apc/htpassword' do
  owner "root"
  group "root"
  mode "0755"
  action :create_if_missing
end

# add user "foo" with password "bar" to "/etc/apc/htpassword"
htpasswd "/etc/apc/htpassword" do
  user "foo"
  password "bar"
end

directory '/srv/www/apc' do
  owner 'deploy'
  group 'deploy'
  action :create
end

cookbook_file "/srv/www/apc/apc.php" do
  owner "deploy"
  group "deploy"
  mode "0755"
end

web_app "apc" do
  docroot "/srv/www/apc"
  template 'apc.conf.erb'
end

