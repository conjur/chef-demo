# chef-demo

Goal: A simple-to-setup & standalone Chef demo configuration showing how Conjur supports secure, automated assignment of identities on a managed host that can securely fetch secrets.

Scenario: Vagrant image with Chef client and Conjur client installed. Chef-solo run assigns identity to an Apache tomcat process that can fetch secrets.

Demo files:
  - DEMORC - resource file to set CONJURRC
  - Vagrantfile - builds Ubuntu 14.04 VM for managed host - DEMO IS RUN FROM INSIDE THIS
  - policy.yml - declarative Conjur security policy
  - run_demo.sh - sets environment variables, obtains HF token and API key, calls chef-solo
  - setup_conjur.sh - called by setup_demo.sh, installs Conjur CLI and initializes connection to Conjur service
  - setup_demo.sh - provisions Chef dev kit, repo, cookbooks and calls setup_conjur.sh
  - solo.rb - Chef file w/ paths to file cache and cookbooks
  - web.json - Chef runbook that drives chef-solo's actions
  
  Subdirectories:
  - templates/ - directory of 
  - nodes/ - Chef-created dir w/ info re: managed host
  - etc/ - cached files for demo setup (solo.rb & web.json)

Demo flow:
  - vagrant up to build VM named vm0
  - vagrant ssh vm0 - log into VM
  - cd to /vagrant and "sudo ./setup_demo.sh" to provision demo - once this is done you don't need an internet connection
  - "./run_demo.sh" - runs demo

Potential enhancements
  - make it actually work :)
