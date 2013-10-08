#
# Cookbook Name:: karaf
# Provider:: feature
#
# Copyright 2013, base2Services
#
# license Apache v2.0
#
require 'net/ssh' 

# Support whyrun
def whyrun_supported?
  true
end

action :install do
	if @current_resource.exists
		Chef::Log.info "#{ @new_resource } already exists - nothing to do."
	else
		converge_by("Karaf feature Install #{ @new_resource }") do
			feature_install	
		end
	end	
end

action :uninstall do
	if @current_resource.exists
		converge_by("Karaf feature uninstall #{ @new_resource }") do
			feature_uninstall	
		end
	else
		Chef::Log.info "#{ @new_resource } already removed - nothing to do."
	end		
end

def load_current_resource
	@current_resource = Chef::Resource::KarafFeature.new(@new_resource.name)
	@current_resource.name(@new_resource.name)
	@current_resource.version(@new_resource.version)

	if feature_exists?(@current_resource.name)
		@current_resource.exists = true
	end
end


private

def feature_exists?(feature)
	Chef::Log.info "Checking to see if this feature exists: '#{ feature }'"
	Net::SSH.start('localhost', 'smx', :password =>'smx', :port =>8101) do |ssh|
		result = ssh.exec!("features:list | grep '#{feature}'")
		return !result.nil? && !result.empty? && result.include?('[installed  ]')
	end	
end

def feature_install
	Net::SSH.start(@new_resource.ssh_host, @new_resource.ssh_user, :password => @new_resource.ssh_pass, :port => @new_resource.ssh_port) do |ssh|
		cmd = "features:install #{@new_resource.name}"
		if(@new_resource.version)
			cmd << "/#{@new_resource.version}"
		end
		Chef::Log.info "Installing Feature: '#{ cmd }'"
		result = ssh.exec!(cmd)
		Chef::Log.info "Output: #{result}"
	end
end

def feature_uninstall
	Net::SSH.start(@new_resource.ssh_host, @new_resource.ssh_user, :password => @new_resource.ssh_pass, :port => @new_resource.ssh_port) do |ssh|
		cmd = "features:uninstall #{@new_resource.name}"
		if(@new_resource.version)
			cmd << "/#{@new_resource.version}"
		end
		Chef::Log.info "Uninstalling Feature: '#{ cmd }'"
		result = ssh.exec!(cmd)
		Chef::Log.info "Output: #{result}"
	end	
end