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
  deb_src false
end
execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end
package 'mesosphere' do
  action :install
end
file "/etc/mesos/zk" do
  content "zk://"+node['ipaddress']+":2181/mesos"
end
file "/etc/zookeeper/conf/myid" do
  content "1"
end
file "/etc/zookeeper/conf/zoo.cfg" do
  content "server.1="+node['ipaddress']+":2888:3888"
end
file "/etc/mesos-master/quorum" do
  content "1"
end
