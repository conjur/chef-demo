# chef-demo

Goal: A simple-to-setup & standalone Chef demo configuration showing how Conjur supports secure, automated assignment of identities on a managed host that can securely fetch secrets.

Scenario: Vagrant image with Chef client and Conjur client installed. Provisioning script installs all resources needed. Running demo script populates environment variables and launches Chef-solo. Conjur helper methods let Chef assign identity to an Apache tomcat process that can fetch secrets. This iteration currently only substitutes values into a Tomcat config template which would be used by a Tomcat app to log into a database.

Demo files:
  - conjur_xxx.deb - NOT PROVISIONED - you need to download this first
    - https://github.com/conjurinc/cli-ruby/releases/download/v5.4.0/conjur_5.4.0-1_amd64.deb
  - Vagrantfile - builds Ubuntu 14.04 VM for managed host - DEMO IS RUN FROM INSIDE THIS
  - setup_demo.sh - provisions Chef dev kit, repo, cookbooks and calls setup_conjur.sh
  - setup_conjur.sh - called by setup_demo.sh, installs Conjur CLI and initializes connection to Conjur service
    - MAKE SURE the CLI deb installation package is accessible in the /vagrant directory
  - run_demo.sh - sets environment variables, obtains HF token and API key, calls chef-solo
  - DEMORC - resource file to set CONJURRC
  - policy.yml - declarative Conjur security policy
  - solo.rb - Chef file w/ paths to file cache and cookbooks
  - web.json - Chef runbook that drives chef-solo's actions
  
  Subdirectories:
  - templates/ - directory containing tokenized XML comfig file in which to substitute values fetched from Conjur
  - nodes/ - Chef-created dir w/ info re: managed host
  - etc/ - cached files for demo setup (solo.rb & web.json)

Demo flow:
  - vagrant up to build VM named vm0
  - vagrant ssh vm0 - log into VM
  - cd to /vagrant and "sudo ./setup_demo.sh" to provision demo - once this is done you don't need an internet connection
  - "./run_demo.sh" - runs demo

Potential enhancements
  - make it actually work :)
