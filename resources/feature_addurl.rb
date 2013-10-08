#
# Cookbook Name:: karaf
# Resource:: feature_addurl
#
# Copyright 2013, base2Services
#
# license Apache v2.0
#
actions :add, :remove, :refresh
default_action :add

# SSH connection attributes
attribute :ssh_user, :kind_of => String, :default => 'smx'
attribute :ssh_pass, :kind_of => String, :default => 'smx'
attribute :ssh_port, :kind_of => Integer, :default => 8101
attribute :ssh_host, :kind_of => String, :default => '127.0.0.1'

attribute :artifact_id, :name_attribute => true, :kind_of => String
attribute :group_id, :kind_of => String
attribute :version, :kind_of => String

attribute :feature_url, :kind_of => String

attr_accessor :exists