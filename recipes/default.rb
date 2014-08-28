# install and configure dependencies
include_recipe "mysql::server"
include_recipe "couchdb"
include_recipe "passenger_nginx"
include_recipe "memcached"
include_recipe "postfix"
include_recipe "phantomjs"

# install additional required packages
%W{ libpq-dev }.each do |pkg|
  package pkg do
    action :install
  end
end

# Create default CouchDB database
http_request "create couchdb database" do
  url "http://#{node['alm']['host']}:#{node['couch_db']['config']['httpd']['port']}/#{node['capistrano']['application']}"
  message ""
  action :put
  ignore_failure true
end

# configure nginx virtual host, and create and symlink shared folders
include_recipe "capistrano::default"

# Add configuration settings to database seed files
template "/var/www/#{node['capistrano']['application']}/shared/db/seeds/_custom_sources.rb" do
  source '_custom_sources.rb.erb'
  owner node['alm']['user']
  group node['alm']['group']
  mode 0644
end

# create settings file
template "/var/www/#{node['capistrano']['application']}/shared/config/settings.yml" do
  source 'settings.yml.erb'
  owner node['capistrano']['deploy_user']
  group node['capistrano']['group']
  mode 0644
  notifies :run, "file[settings.yml]", :immediately
end

# copy settings file
file "settings.yml" do
  path "/var/www/#{node['capistrano']['application']}/shared/config/settings.yml"
  content ::File.open("/var/www/#{node['capistrano']['application']}/current/config/settings.yml").read
  owner node['capistrano']['deploy_user']
  group node['capistrano']['group']
  mode 0644
end

# create and symlink shared folders, bundle install gems, precompile assets and run migrations
include_recipe "capistrano::deploy"

# restart passenger
bash "restart passenger" do
  cwd  "/var/www/#{node['capistrano']['application']}/current"
  code "mkdir -p tmp && touch tmp/restart.txt"
end
