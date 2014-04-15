#credits: http://clarkdave.net/2013/02/send-deploy-keys-to-bitbucket-in-a-chef-recipe/
#execute is idempotent with 'creates' and ruby_block 'action: none' so this recipe will only run once.

chef_gem 'httparty'

# create their ssh key
execute 'generate ssh key for deploy' do
  user node['server']['user']
  creates "/home/#{node['server']['user']}/.ssh/id_rsa"
  command "ssh-keygen -t rsa -q -f /home/#{node['server']['user']}/.ssh/id_rsa -P ''"
  notifies :create, "ruby_block[add_ssh_key_to_bitbucket]"
  notifies :run, "execute[add_bitbucket_to_known_hosts]"
end

# add bitbucket.org to known hosts, so future deploys won't be interrupted
execute "add_bitbucket_to_known_hosts" do
  action :nothing # only run when ssh key is created
  user 'deploy'
  command 'ssh-keyscan -H bitbucket.org >> /home/deploy/.ssh/known_hosts'
end

# send id_rsa.pub over to Bitbucket as a new deploy key
ruby_block "add_ssh_key_to_bitbucket" do
  action :nothing # only run when ssh key is created
  block do
    require 'httparty'
    url = "https://bitbucket.org/api/1.0/repositories/#{node['bitbucket_account_name']}/#{node['bitbucket_repo_name']}/deploy-keys"
    response = HTTParty.post(url, {
      :basic_auth => {
        :username => node['bitbucket_user'],
        :password => node['bitbucket_password']
      },
      :body => {
        :label => 'deploy@' + node['ipaddress'],
        :key => File.read("/home/#{node['server']['user']}/.ssh/id_rsa.pub")
      }
    })
    #debug help
    #Chef::Log.warn("https://bitbucket.org/api/1.0/repositories/#{node['bitbucket_user']}/#{node['bitbucket_repo_name']}/deploy-keys")
    #Chef::Log.warn("#{response.code}")
    unless response.code == 200 or response.code == 201
      Chef::Log.warn("Could not add deploy key to Bitbucket, response: #{response.body}")
      Chef::Log.warn("Add the key manually:")
      Chef::Log.info(File.read("/home/#{node['server']['user']}/.ssh/id_rsa.pub"))
    end
  end
end