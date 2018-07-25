#
# Cookbook Name:: zabbix-agent
# Attributes:: default

# Directories
#default['zabbix']['etc_dir'] = case node['platform_family']
#                               when 'windows'
#                                 ::File.join(ENV['PROGRAMDATA'], 'zabbix')
#                               else
#                                 '/etc/zabbix'
#                               end
#default['zabbix']['agent']['include_dir']            = ::File.join(node['zabbix']['etc_dir'], 'zabbix_agentd.d')
#default['zabbix']['agent']['config_file']            = ::File.join(node['zabbix']['etc_dir'], 'zabbix_agentd.conf')
#default['zabbix']['agent']['userparams_config_file'] = ::File.join(node['zabbix']['agent']['include_dir'], 'user_params.conf')
#default['zabbix']['agent']['pid_file']               = '/var/run/zabbix/zabbix_agentd.pid'
#if node['platform'] == 'windows'
#  default['zabbix']['install_dir']      = node['zabbix']['etc_dir']
#  default['zabbix']['log_dir']          = ::File.join(node['zabbix']['etc_dir'], 'log')
#  default['zabbix']['agent']['scripts'] = ::File.join(node['zabbix']['etc_dir'], 'scripts')
#else
#  default['zabbix']['install_dir']      = '/opt/zabbix'
#  default['zabbix']['lock_dir']         = '/var/lock/subsys'
#  default['zabbix']['log_dir']          = '/var/log/zabbix'
#  default['zabbix']['run_dir']          = '/var/run/zabbix'
#  default['zabbix']['agent']['scripts'] = '/etc/zabbix/scripts'
#end

# package conf
default['zabbix']['agent']['version'] = '3.4'
default['zabbix']['agent']['config_file'] = '/etc/zabbix/zabbix_agentd.conf'

# zabbix-server
default['zabbix']['server']['ip'] = '10.124.26.5'

# repo package install
case node['platform']
when 'ubuntu', 'debian'
  default['zabbix']['agent']['package']['repo_uri'] = "http://repo.zabbix.com/zabbix/3.0/#{node['platform']}/"
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/zabbix-official-repo.key'
when 'redhat', 'centos', 'scientific', 'oracle'
  default['zabbix']['agent']['package']['repo_uri'] = 'http://repo.zabbix.com/zabbix/3.0/rhel/$releasever/$basearch/'
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
when 'amazon'
  # current Amazon AMI based on RHEL6 at the moment
  default['zabbix']['agent']['package']['repo_uri'] = 'http://repo.zabbix.com/zabbix/3.0/rhel/6/$basearch/'
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
when 'fedora'
  default['zabbix']['agent']['package']['repo_uri'] = 'http://repo.zabbix.com/zabbix/3.0/rhel/7/$basearch/'
  default['zabbix']['agent']['package']['repo_key'] = 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX'
end
