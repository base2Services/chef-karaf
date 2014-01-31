#
# Cookbook Name:: karaf
# Recipe:: default
#
# Copyright 2013, base2Services
#

karaf_version = node[:karaf][:version]
karaf_revision = node[:karaf][:revision]
karaf_dir_root = node[:karaf][:karaf_root]
karaf_download_url = node[:karaf][:download_url]
karaf_system_user = node[:karaf][:system_user]

# Fuse base directory
directory "#{karaf_dir_root}" do
   owner "root"
   group "root"
   mode 00755
   action :create
end

# Create fuseESB user
user "#{karaf_system_user}" do
   comment "Apache Karaf system user"
   home "/home/#{karaf_system_user}"
   system true
   shell "/bin/bash"
   supports :manage_home => true
   action :create
end

# Download FuseESB

Chef::Log.info "Downloading and Installing Karaf to #{karaf_dir_root}/karaf-#{karaf_version}-#{karaf_revision}"
ark "karaf" do
  prefix_root "#{karaf_dir_root}"
  url "#{karaf_download_url}"
  version "#{karaf_version}"
  checksum 'a3b5ad464ddb6acb55537e2bdba0342bf511798b0a32bed36b789a170cea9a79'
  owner "#{karaf_system_user}" 
  home_dir "#{karaf_dir_root}/karaf"
  action :install
end

#include_recipe "karaf::karaf-esb-service"
#include_recipe "karaf::users"
#include_recipe "karaf::etc"