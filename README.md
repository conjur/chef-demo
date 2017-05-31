# chef-demo

Goal: A simple-to-setup Chef demo configuration that can run on a laptop w/o internet connectivity, showing how Conjur supports secure, automated assignment of identities on a managed host that can securely fetch secrets.

Prerequisites:
  - a running Conjur master or cluster (local or remote)
  - Virtualbox & Vagrant installed

Scenario: Vagrant image with Chef solo client and Conjur client installed. Provisioning script installs all resources needed. Running the demo script populates environment variables and launches Chef-solo. Conjur helper methods let Chef assign identity to an Apache tomcat process that can fetch secrets. This iteration currently only substitutes values into a Tomcat config template which would be used by a Tomcat app to log into a database.

Demo files:
  - Conjur CLI installation package (conjur_5.4.0-1_amd64.deb) - YOU NEED TO DOWNLOAD THIS after cloning this repo
    - https://github.com/conjurinc/cli-ruby/releases/download/v5.4.0/conjur_5.4.0-1_amd64.deb
  - Vagrantfile - builds Ubuntu 14.04 VM for managed host - DEMO IS RUN FROM INSIDE THIS
  - setup_demo.sh - provisions Chef dev kit, repo, cookbooks and calls setup_conjur.sh
  - setup_conjur.sh - called by setup_demo.sh, installs Conjur CLI and initializes connection to Conjur service
    - MAKE SURE the Conjur CLI deb installation package is in the /vagrant directory
  - run_demo.sh - sets environment variables, obtains HF token and API key, calls chef-solo
  - policy.yml - declarative Conjur security policy
  - solo.rb - Chef solo config file w/ paths to file cache and cookbooks
  - web.json - Chef runbook that drives chef-solo's actions
  
  Subdirectories:
  - templates/ - directory containing tokenized XML comfig file in which to substitute values fetched from Conjur
  - etc/ - cached files for demo setup - copied to phpapp cookbook
    - default.rb - copied to /root/chef-repo/cookbooks/phpapp/recipes - THIS IS WHERE THE CONJUR MAJIC IS INVOKED
    - metadata.rb - copied to /root/chef-repo/cookbooks/phpapp - documents dependent cookbooks

Demo flow:
  - vagrant up to build VM named vm0
  - vagrant ssh vm0 - log into VM
  - cd to /vagrant and "sudo ./setup_demo.sh" to provision demo - once this is done you don't need an internet connection if you have a Conjur master running on your laptop
  - "./run_demo.sh" - runs demo

Potential enhancements
  - make it actually work :)
