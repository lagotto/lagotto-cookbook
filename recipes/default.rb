# install and configure dependencies
include_recipe "memcached"
include_recipe "postfix"
include_recipe "phantomjs"
include_recipe "mysql::server"
include_recipe "couchdb"
include_recipe "passenger_nginx"
include_recipe "capistrano"

# Add configuration settings to database seed files
template "/var/www/alm/shared/db/seeds/_custom_sources.rb" do
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

# require 'securerandom'
# # Create new settings.yml unless it exists already
# # Set these passwords in config.json to keep them persistent
# unless File.exists?("/var/www/alm/shared/config/settings.yml")
#   node.set['alm']['key'] = SecureRandom.hex(30) unless node['alm']['key']
#   node.set['alm']['secret'] = SecureRandom.hex(30) unless node['alm']['secret']
#   node.set['alm']['api_key'] = SecureRandom.hex(30) unless node['alm']['api_key']
# else
#   settings = YAML::load(IO.read("/var/www/alm/shared/config/settings.yml"))
#   rest_auth_site_key = settings["#{node['alm']['environment']}"]["rest_auth_site_key"]
#   secret_token = settings["#{node['alm']['environment']}"]["secret_token"]
#   api_key = settings["#{node['alm']['environment']}"]["api_key"]

#   node.set_unless['alm']['key'] = rest_auth_site_key
#   node.set_unless['alm']['secret'] = secret_token
#   node.set_unless['alm']['api_key'] = api_key
# end

# create settings file
template "/var/www/#{node['capistrano']['application']}/shared/config/settings.yml" do
  source 'settings.yml.erb'
  owner node['capistrano']['deploy_user']
  group node['capistrano']['group']
  mode 0644
end

# restart passenger
file "/var/www/#{node['capistrano']['application']}/current/tmp/restart.txt" do
  owner node['capistrano']['deploy_user']
  group node['capistrano']['group']
  action :create
end
