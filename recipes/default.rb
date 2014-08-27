# install and configure dependencies
include_recipe "mysql::server"
include_recipe "couchdb"
include_recipe "passenger_nginx"
include_recipe "memcached"
include_recipe "postfix"
include_recipe "phantomjs"
include_recipe "capistrano"

# install additional required packages
%W{ libpq-dev }.each do |pkg|
  package pkg do
    action :install
  end
end

# create additional shared folders
%w{ shared/db/seeds shared/public/files }.each do |dir|
  directory "/var/www/#{node['capistrano']['application']}/#{dir}" do
    owner node['capistrano']['deploy_user']
    group node['capistrano']['group']
    mode 0755
    recursive true
  end
end

# Add configuration settings to database seed files
template "/var/www/#{node['capistrano']['application']}/shared/db/seeds/_custom_sources.rb" do
  source '_custom_sources.rb.erb'
  owner node['alm']['user']
  group node['alm']['group']
  mode 0644
end

# Create default CouchDB database
script "create CouchDB database #{node['alm']['name']}" do
  interpreter "bash"
  code "curl -X PUT http://#{node['alm']['host']}:#{node['couch_db']['config']['httpd']['port']}/#{node['alm']['name']}/"
  ignore_failure true
end

# create settings file
template "/var/www/#{node['capistrano']['application']}/shared/config/settings.yml" do
  source 'settings.yml.erb'
  owner node['capistrano']['deploy_user']
  group node['capistrano']['group']
  mode 0644
end

# restart passenger
bash "restart passenger" do
  cwd  "/var/www/#{node['capistrano']['application']}/current"
  code "mkdir -p tmp && touch tmp/restart.txt"
end
