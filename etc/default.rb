#
# Cookbook Name:: phpapp
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
include_recipe "conjur"
include_recipe "conjur-host-identity"

apache_site "default" do
  enable true
end

template '/etc/webapp1.xml' do
  source 'myapp.xml.erb'
  variables({
    :database_password => fetch_conjur_variable('demo/webapp1/database_password'),
    :api_token => fetch_conjur_variable('demo/webapp1/api_key')
  })
end
