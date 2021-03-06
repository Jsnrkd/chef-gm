#1.0.0 Initial import


- Examples and tutorials on how to provision this stack locally and remotely
- Highly configurable parameters for packages in one place
- Installs a LAMP stack with separate configurations for development and production
- Stack tuned with defaults and suggested scaling
- Upgraded 12.04 packages from dotdeb.org like PHP 5.4
- Creates users and ssh keys and configures authorized users.
- Creates directories and permissions for users and applications.
- Adds aliases for repetitive CLI commands.
- Adds deploy user keys to bitbucket via API
- Imports database from AWS S3 or file.
- Basic security with OpenSSH, UFW, and Fail2ban 
- Disables root user access and requires key pair authentication with OpenSSH
- Implements a default firewall allowing traffic from ports 80 and 443 with UFW
- Prevents multiple failed login attempts with Fail2ban
- Configures directories for Capistrano application deployment
- Enables swap space on VPS providers
- Syncs internal clock with NTP
- Auto updates security and version updates of Ubuntu packages daily with unattended upgrades
- Backs up databases daily to AWS S3 via cron.
- Configures Xdebug for development.
- Uses APC for opcode cache
- Configures http basic auth for access of dashboards like APC
- Installs Google's Page Speed Apache module.