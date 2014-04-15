#There are many attributes not listed here.  Check the corresponding cookbook's github repo for details.

#default global email address
default['email_address'] = 'local@localhost.com'

#BitBucket
#Provide user info for someone with access to the repo.
#user name is not your email address
default['bitbucket_user'] = ''
default['bitbucket_password'] = ''
#Account name is who owns the repository. It's either your username or the team name.
default['bitbucket_account_name'] = ''
default['bitbucket_repo_name'] = ''


#App
default['app']['hostname'] = 'example'
default['app']['fqdn'] = 'example.dev'
default['app']['name'] = 'example'
default['app']['config'] = 'example.conf'
default['app']['app_root'] = '/srv/www/example'
default['app']['document_root'] = "#{node['app']['app_root']}/current/httpdocs"
default['app']['environment'] = 'development'

#App Database
default['app']['database']['prefix'] = 'dev'
default['app']['database']['dbname'] = "#{node['app']['database']['prefix']}_example"
default['app']['database']['migration_user']['username'] = 'migration_admin'
default['app']['database']['migration_user']['password'] = 'wuki5hu3pe'
default['app']['database']['app_user']['username'] = 'app_admin'
default['app']['database']['app_user']['password'] = 'wuth1gu4wu'

#Server Users
default['server']['user'] = 'deploy'
default['server']['group'] = 'deploy'
default['server']['authorized_keys'] = ['']
default['authorization']['sudo']['users'] = [default['server']['user']]


#AWS
default['s3cmd']['access_key'] = ''
default['s3cmd']['secret_key'] = ''
default["s3cmd"]["use_https"] = true
default['s3cmd']['user'] = 'deploy'
default['s3cmd']['config_dir'] = "/home/#{node['server']['user']}"

#Server settings
#Swap discussion https://help.ubuntu.com/community/SwapFaq#What_is_swappiness_and_how_do_I_change_it.3F
default['server']['swap']['size'] = 2048 # MBs

#OpenSSH
default['openssh']['server']['password_authentication'] = 'no'
default['openssh']['server']['permit_root_login'] = 'no'
#default['openssh']['server']['port'] = '3468'

#Firewall
default['firewall']['rules'] = [
	{ 'http' => { 'port' => '80' } }, 
	{ 'http' => { 'port' => '443' } }]

#Apache
default['apache']['contact'] = default['email_address']

#PHP
default['php']['conf_dir'] = '/etc/php5/apache2'
default['php']['ini']['template'] = 'php.ini.erb'
default['php']['ini']['cookbook'] = 'app'
default['php']['display_errors'] = 'Off'

#XDebug
default['php']['xdebug']['enable'] = false
#PHP 5.3: 20090626 5.4: 20100525
default['php']['xdebug']['zend_extension'] = '/usr/lib/php5/20100525/xdebug.so'
default['php']['xdebug']['remote_enable'] = '1'
default['php']['xdebug']['remote_connect_back'] = '1'
default['php']['xdebug']['remote_host'] = '172.22.22.72'
default['php']['xdebug']['remote_port'] = '9000'
default['php']['xdebug']['remote_handler'] = 'dbgp'
default['php']['xdebug']['profiler_enable'] = '0'
default['php']['xdebug']['profiler_enable_trigger'] = 'true'
default['php']['xdebug']['profiler_output_dir'] = '/var/tmp'
default['php']['xdebug']['profiler_output_name'] = 'cachegrind.out.%R.%t'

#APC

#APT
default['unattended-upgrades']['update_package_lists_interval'] = "1" #1 = daily
default['unattended-upgrades']['upgrade_interval'] = "1"
default['unattended-upgrades']['origins'] = ['Ubuntu precise-security', 'Ubuntu precise-updates']
default['unattended-upgrades']['send_email'] = false
default['unattended-upgrades']['email_address'] = default['email_address']
default['unattended-upgrades']['auto_remove'] = false
default['unattended-upgrades']['auto_reboot'] = false

#MySQL
default['mysql']['port'] = '3306'
default['mysql']['address'] = '127.0.0.1'
default['mysql']['remove_test_database'] = 'yes'
#default['mysql']['server_root_password'] = 'changeme'

#These apache environment variables get places in the vhost file
default['apache']['env_vars'] = { EXAMPLE_VAR: "1",
								 EXAMPLE_VAR2: "1"
								}


#NTP
#these defaults were found at http://www.pool.ntp.org/zone/north-america
default['ntp']['servers'] = ['0.north-america.pool.ntp.org', '1.north-america.pool.ntp.org', '2.north-america.pool.ntp.org', '3.north-america.pool.ntp.org']