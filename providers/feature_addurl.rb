#
# Cookbook Name:: karaf
# Provider:: feature_addurl
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

action :add do
	if @current_resource.exists
		Chef::Log.info "#{ @new_resource } already exists - nothing to do."
	else
		converge_by("Karaf features addurl #{ @new_resource }") do
			feature_add_url	
		end
	end
end

action :remove do
	if @current_resource.exists
		converge_by("Karaf features removeurl #{ @new_resource }") do
			feature_remove_url	
		end
	else
		Chef::Log.info "#{ @new_resource } already removed - nothing to do."
	end	
end

action :refresh do
	converge_by("Karaf features refreshurl #{ @new_resource }") do
		feature_refresh_url
	end
end

def load_current_resource
	@current_resource = Chef::Resource::KarafFeatureAddurl.new(@new_resource.name)
	@current_resource.name(@new_resource.name)
	@current_resource.group_id(@new_resource.group_id)
	@current_resource.version(@new_resource.version)
	if @new_resource.feature_url
		@current_resource.feature_url("#{@new_resource.feature_url}")
	elsif @new_resource.group_id
		@current_resource.feature_url("mvn:#{@new_resource.group_id}/#{@new_resource.name}/#{@new_resource.version}/xml/features")
	else
		@current_resource.feature_url('')
	end

	if !@current_resource.feature_url.empty?
		if feature_url_exists?(@current_resource.feature_url)
			@current_resource.exists = true
		end
	end
end

private

def feature_url_exists?(url)
	Chef::Log.info "Checking to see if this feature url exists: '#{ url }'"
	Net::SSH.start('localhost', 'smx', :password =>'smx', :port =>8101) do |ssh|
		result = ssh.exec!("features:listurl | grep '#{url}'")
		return !result.nil? && !result.empty?
	end	
end

def feature_add_url
	Net::SSH.start(@new_resource.ssh_host, @new_resource.ssh_user, :password => @new_resource.ssh_pass, :port => @new_resource.ssh_port) do |ssh|
		cmd = 'features:addurl'
		if(@new_resource.feature_url)
			cmd << " #{@new_resource.feature_url}"
		else
			cmd << " mvn:#{@new_resource.group_id}/#{@new_resource.name}/#{@new_resource.version}/xml/features"
		end
		Chef::Log.info "Adding Feature Url: '#{ cmd }'"
		result = ssh.exec!(cmd)
		Chef::Log.info "Output: #{result}"
	end
end

def feature_remove_url
	Net::SSH.start(@new_resource.ssh_host, @new_resource.ssh_user, :password => @new_resource.ssh_pass, :port => @new_resource.ssh_port) do |ssh|
		cmd = 'features:removeurl'
		if(@new_resource.feature_url)
			cmd << " #{@new_resource.feature_url}"
		else
			cmd << " mvn:#{@new_resource.group_id}/#{@new_resource.name}/#{@new_resource.version}/xml/features"
		end
		Chef::Log.info "Remove Feature Url: '#{ cmd }'"
		result = ssh.exec!(cmd)
		Chef::Log.info "Output: #{result}"
	end
end

def feature_refresh_url
	Net::SSH.start(@new_resource.ssh_host, @new_resource.ssh_user, :password => @new_resource.ssh_pass, :port => @new_resource.ssh_port) do |ssh|
		cmd = 'features:refreshurl'
		if(@new_resource.feature_url)
			cmd << " #{@new_resource.feature_url}"
		elsif(@new_resource.group_id)
			cmd << " mvn:#{@new_resource.group_id}/#{@new_resource.name}/#{@new_resource.version}/xml/features"
		end
		Chef::Log.info "Refresh Feature Url: '#{ cmd }'"
		result = ssh.exec!(cmd)
		Chef::Log.info "Output: #{result}"
	end
end