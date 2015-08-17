#
# Cookbook Name:: maven
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt::default'
apt_repository 'mesosphere' do
  uri 'http://repos.mesosphere.io/ubuntu'
  components ['main']
  key 'E56151BF'
  keyserver 'keyserver.ubuntu.com'
  distribution node['lsb']['codename']
  action :add
end
package 'mesos' do
  action :install
end
file "/etc/init/zookeeper.override" do
  content 'manual'
end
file "/etc/init/mesos-master.override" do
  content 'manual'
end
file "/etc/mesos-slave/ip" do
  content node['ipaddress']
end
file "/etc/mesos-slave/hostname" do
  content node['ipaddress']
end
