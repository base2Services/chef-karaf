#
# Cookbook Name:: karaf
# Resource:: feature
#
# Copyright 2013, base2Services
#
# license Apache v2.0
#
actions :install, :uninstall
default_action :install

# SSH connection attributes
attribute :ssh_user, :kind_of => String, :default => 'smx'
attribute :ssh_pass, :kind_of => String, :default => 'smx'
attribute :ssh_port, :kind_of => Integer, :default => 8101
attribute :ssh_host, :kind_of => String, :default => '127.0.0.1'

attribute :feature_name, :name_attribute => true, :kind_of => String
attribute :version, :kind_of => String

attr_accessor :exists