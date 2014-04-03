#
# Cookbook Name:: jpetstore
# Recipe:: database
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

include_recipe 'mysql::server'
include_recipe 'mysql-chef_gem::default'

mysql_connection_info = { :host => 'localhost',
                          :username => 'root',
                          :password => node['mysql']['server_root_password'] }

mysql_database 'jpetstore' do
  connection mysql_connection_info
  action :create
end

cookbook_file "#{Chef::Config[:file_cache_path]}/jpetstore-mysql-schema.sql" do
  source 'jpetstore-mysql-schema.sql'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'initialize jpetstore database' do
  command "mysql -h localhost -u root -p#{node['mysql']['server_root_password']} -D jpetstore < #{Chef::Config[:file_cache_path]}/jpetstore-mysql-schema.sql"
  not_if "mysql -h localhost -u root -p#{node['mysql']['server_root_password']} -D jpetstore -e 'describe inventory;'"
end
