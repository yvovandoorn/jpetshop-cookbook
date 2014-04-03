#
# Cookbook Name:: jpetstore
# Recipe:: default
#
# Copyright (C) 2014 Chef Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'jpetstore::database'

tcserver_instance 'jpetstore' do
  action :create
end

directory '/opt/vmware/vfabric-tc-server-standard/jpetstore/webapps/ROOT' do
  action :delete
  recursive true
  not_if { ::File.exists?('/opt/vmware/vfabric-tc-server-standard/jpetstore/webapps/ROOT.war') }
end

remote_file '/opt/vmware/vfabric-tc-server-standard/jpetstore/webapps/ROOT.war' do
  owner 'root'
  group 'root'
  mode '0644'
  source node['jpetstore']['war_url']
  checksum node['jpetstore']['war_sum']
end

template "/opt/vmware/vfabric-tc-server-standard/jpetstore/bin/setenv.sh" do
  source "setenv.sh.erb"
  owner "root"
  group "root"
  mode "0755"
end

simple_iptables_rule "tcserver" do
  rule "--proto tcp --dport 8080"
  jump "ACCEPT"
end

tcserver_ctl 'jpetstore' do
  action :start
end

