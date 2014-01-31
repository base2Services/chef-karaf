#
# Cookbook Name:: karaf
# Attribute File:: default
#
# Copyright 2013, base2Services
#

default[:karaf][:karaf_root] = "/opt/karaf"
default[:karaf][:karaf_artifact] = "apache-karaf"
default[:karaf][:version] = "3.0.0"
default[:karaf][:base_dir] = "#{node[:karaf][:karaf_root]}/apache-karaf-#{node[:karaf][:version]}"
default[:karaf][:download_url] = "http://www.apache.org/dyn/closer.cgi/karaf/#{node[:karaf][:version]}/apache-karaf-#{node[:karaf][:version]}.tar.gz"
default[:karaf][:system_user] = "karaf"
default[:karaf][:users] = [{:name => 'smx', :password => 'smx', :roles => ['admin']}]

