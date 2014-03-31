---
layout: page
title:  Getting Started
lead:   Stuff you need to know
---

During the application development cycle you will need some combination of development, staging, testing, production, and monitoring servers.  Managing a group of servers gets old pretty quick when you have more than one or two.  A sane way of managing multiple servers is through Chef Solo.  As you'll see, the [Chef-gm](https://github.com/Jsnrkd/chef-gm) project comes with a pre-configured example that you can run on a virtual machine or a remote VPS provider.


To follow along, here are the things you should minimally install.

#Chef-gm Workflow

This is a simplification of the steps involved

1. Fork [Chef-gm](https://github.com/Jsnrkd/chef-gm) on Github.
2. Install dependencies
3. Provision the test project with Vagrant in a local VM.
4. Configure your environment attributes for your custom application
5. Configure your run node run list
6. Provision
7. Return to step 4




