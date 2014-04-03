# Sets up jpetstore deps
# Does not deploy actual app

include_recipe 'tcserver::default'
include_recipe 'mysql::server'
include_recipe 'mysql-chef_gem::default'
