#
# Cookbook Name:: zabbix-agent
# Attributes:: default

# package conf
default['zabbix']['agent']['version'] = '1:3.4.11-1+xenial'
default['zabbix']['agent']['conf_dir'] = '/etc/zabbix'
default['zabbix']['agent']['config_file'] = ::File.join(node['zabbix']['agent']['conf_dir'],'zabbix_agentd.conf')
default['zabbix']['agent']['user'] = 'root'

# zabbix-server
default['zabbix']['server']['ip'] = '10.124.26.5'

# repo package install
case node['platform']
when 'ubuntu', 'debian'
  default['zabbix']['agent']['package']['repo_uri'] = 'http://repo.zabbix.com/zabbix/3.4/ubuntu'
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/zabbix-official-repo.key'
when 'redhat', 'centos', 'scientific', 'oracle'
  default['zabbix']['agent']['package']['repo_uri'] = 'http://repo.zabbix.com/zabbix/3.4/rhel/$releasever/$basearch/'
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
when 'amazon'
  # current Amazon AMI based on RHEL6 at the moment
  default['zabbix']['agent']['package']['repo_uri'] = 'http://repo.zabbix.com/zabbix/3.4/rhel/6/$basearch/'
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
when 'fedora'
  default['zabbix']['agent']['package']['repo_uri'] = 'http://repo.zabbix.com/zabbix/3.4/rhel/7/$basearch/'
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
end
