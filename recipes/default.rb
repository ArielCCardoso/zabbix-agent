#
# Cookbook:: zabbix-agent
# Recipe:: default
#
# Copyright:: 2018, Ariel Cardoso, All Rights Reserved.

#include_recipe 'build-essential'
#include_recipe 'zabbix-agent::install'

case node['platform']
when 'windows'
  include_recipe 'chocolatey'
  chocolatey 'zabbix-agent'
when 'ubuntu', 'debian'
  apt_repository 'zabbix' do
    uri node['zabbix']['agent']['package']['repo_uri']
    distribution node['lsb']['codename']
    components ['main']
    key node['zabbix']['agent']['package']['repo_key']
  end
when 'redhat', 'centos', 'scientific', 'oracle', 'amazon', 'fedora'
  yum_repository 'zabbix' do
    repositoryid 'zabbix'
    description 'Zabbix Official Repository'
    baseurl node['zabbix']['agent']['package']['repo_uri']
    gpgkey node['zabbix']['agent']['package']['repo_key']
    sslverify false
    action :create
  end
  yum_repository 'zabbix-non-supported' do
    repositoryid 'zabbix-non-supported'
    description 'Zabbix Official Repository non-supported - $basearch'
    baseurl node['zabbix']['agent']['package']['repo_uri']
    gpgkey node['zabbix']['agent']['package']['repo_key']
    sslverify false
    action :create
  end
end

package 'zabbix-agent' do
  version node['zabbix']['agent']['version']
  if node['platform_family'] == 'debian'
    options '-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"'
  end
  action :install
end

execute 'enable_service' do
  command   'systemctl enable zabbix-agent.service'
  group     node['zabbix']['agent']['user']
  user      node['zabbix']['agent']['user']
  action    :nothing
end

execute 'umask_service' do
  command   'systemctl unmask zabbix-agent.service'
  group     node['zabbix']['agent']['user']
  user      node['zabbix']['agent']['user']
  action    :nothing
  notifies :run, 'execute[enable_service]', :immediately
end

execute 'daemon_reload' do
  command   'systemctl daemon-reload'
  group     node['zabbix']['agent']['user']
  user      node['zabbix']['agent']['user']
  action    :nothing
  notifies :run, 'execute[umask_service]', :immediately
end

template 'zabbix-service' do
  path '/etc/systemd/system/zabbix-agent.service'
  source 'zabbix-agent.service.erb'
  owner node['zabbix']['agent']['user']
  group node['zabbix']['agent']['user']
  mode '0700'
  action :create
  notifies :run, 'execute[daemon_reload]', :immediately
end

template 'zabbix-conf' do
  path node['zabbix']['agent']['config_file']
  source 'zabbix_agentd.erb'
  owner node['zabbix']['agent']['user']
  group node['zabbix']['agent']['user']
  mode '0700'
  variables(
    zabbixServer: node['zabbix']['server']['ip'])
  action :create
  #notifies :run, 'template[zabbix-conf]', :immediately
end

service 'zabbix-agent' do
  pattern 'zabbix-agent.service'
  #restart_command ''
  subscribes :restart, 'template[zabbix-conf]', :immediately
end
