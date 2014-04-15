# Makes sure apt is up to date
include_recipe "apt"

# Install app packages
node['app']['packages'].each do |a_package|
  package a_package
end