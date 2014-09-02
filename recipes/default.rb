# install and configure dependencies
include_recipe "couchdb"
include_recipe "memcached"
include_recipe "postfix"
include_recipe "phantomjs"

# include_recipe "passenger_nginx"

# install mysql and create configuration file and database
mysql_rails node['alm']['name'] do
  username        node['alm']['db']['user']
  password        node['alm']['db']['password']
  host            node['alm']['db']['host']
  rails_env       node['alm']['rails_env']
  action          [:config, :setup]
end

# create CouchDB database
bash "create CouchDB database" do
  code            "curl -X PUT #{node['alm']['couchdb']['url']}"
  returns         [0, 127]
end

# install nginx and create configuration file and application root
passenger_nginx node['alm']['name'] do
  rails_env       node['alm']['rails_env']
  default_server  node['alm']['web']['default_server']
end

# create configuration files
capistrano_template "config/settings.yml" do
  source          "settings.yml.erb"
  application     node['alm']['name']
  params          node['alm']['settings']
end

capistrano_template "db/seeds/_custom_sources.rb" do
  source          "_custom_sources.rb.erb"
  application     node['alm']['name']
  params          node['alm']['sources']
end

# create required files and folders, and deploy application
capistrano node['alm']['name'] do
  rails_env       node['alm']['rails_env']
  action          [:config, :bundle_install, :precompile_assets, :migrate, :restart]
end
