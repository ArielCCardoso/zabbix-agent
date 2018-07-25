#
# Cookbook:: zabbix-agent
# Recipe:: install
#
# Copyright:: 2018, The Authors, All Rights Reserved.

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
    notifies :run, 'execute[apt-get update]', :immediately
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

template 'zabbix-conf' do
  path node['zabbix']['agent']['config_file']
  source 'zabbix_agentd.erb'
  owner node['zabbix']['agent']['user']
  group node['zabbix']['agent']['user']
  mode '0700'
  variables(
    zabbixServer: node['zabbix']['server']['ip'])
  action :create
  notifies :restart, 'service[zabbix-agent]'
end
