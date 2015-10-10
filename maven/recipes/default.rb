#
# Cookbook Name:: maven
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'apt::default'
include_recipe 'java::oracle'
apt_repository 'mesosphere' do
  uri 'http://repos.mesosphere.io/ubuntu'
  components ['main']
  key 'E56151BF'
  keyserver 'keyserver.ubuntu.com'
  distribution node['lsb']['codename']
  action :add
  deb_src false
end
apt_repository 'java8' do
#  uri "ppa:webupd8team/java"
  uri "ppa:openjdk-r/ppa"
  distribution node['lsb']['codename']
end
package 'mesosphere' do
  action :install
#  options '--force-yes'
end
file "/etc/mesos/zk" do
  content "zk://"+node['ipaddress']+":2181/mesos"
end
file "/etc/mesos-master/quorum" do
  content node['maven']['quorum']
end
service "mesos-slave" do
  action :stop
end
file "/etc/init/mesos-slave.override" do
  content "manual"
end
directory '/etc/zookeeper/conf' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
file "/etc/zookeeper/conf/myid" do
  content "1"
end
file "/etc/zookeeper/conf/zoo.cfg" do
  content "server.1="+node['ipaddress']+":2888:3888"
end
service "zookeeper" do
  action :restart
end
template 'mesos-master-init' do
  path '/etc/init.d/mesos-master'
  source 'sysvinit_debian.erb'
end
service "mesos-master" do
  action :restart
end
service "marathon" do
  action :restart
end
