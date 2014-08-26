require 'securerandom'
# Create new settings.yml unless it exists already
# Set these passwords in config.json to keep them persistent
unless File.exists?("/var/www/alm/shared/config/settings.yml")
  node.set['alm']['key'] = SecureRandom.hex(30) unless node['alm']['key']
  node.set['alm']['secret'] = SecureRandom.hex(30) unless node['alm']['secret']
  node.set['alm']['api_key'] = SecureRandom.hex(30) unless node['alm']['api_key']
else
  settings = YAML::load(IO.read("/var/www/alm/shared/config/settings.yml"))
  rest_auth_site_key = settings["#{node[:alm][:environment]}"]["rest_auth_site_key"]
  secret_token = settings["#{node[:alm][:environment]}"]["secret_token"]
  api_key = settings["#{node[:alm][:environment]}"]["api_key"]

  node.set_unless['alm']['key'] = rest_auth_site_key
  node.set_unless['alm']['secret'] = secret_token
  node.set_unless['alm']['api_key'] = api_key
end

template "/var/www/alm/shared/config/settings.yml" do
  source 'settings.yml.erb'
  owner node[:alm][:user]
  group node[:alm][:group]
  mode 0644
end

# Add configuration settings to database seed files
template "/var/www/alm/shared/db/seeds/_custom_sources.rb" do
  source '_custom_sources.rb.erb'
  owner node[:alm][:user]
  group node[:alm][:group]
  mode 0644
end

# install and configure couchdb
include_recipe "alm::couchdb"

# caching
include_recipe "memcached::default"

# install mail server
include_recipe "postfix::default"

# for testing
include_recipe "phantomjs::default"
