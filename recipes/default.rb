# install and configure dependencies
include_recipe "couchdb"
include_recipe "memcached"
include_recipe "postfix"
include_recipe "phantomjs"

# install mysql and create configuration file and database
mysql_rails 'alm' do
  action          [:config, :setup]
end

# create CouchDB database
bash "create CouchDB database" do
  code            "curl -X PUT #{node['alm']['couchdb']['url']}"
  returns         [0, 127]
end

# install nginx and create configuration file and application root
passenger_nginx 'alm' do
  action          :config
end

# create configuration files
capistrano_template 'config/settings.yml' do
  source          'settings.yml.erb'
  application     'alm'
  params          node['alm']['settings']
end

capistrano_template 'db/seeds/_custom_sources.rb' do
  source          '_custom_sources.rb.erb'
  application     'alm'
  params          node['alm']['sources']
end

# create required files and folders, and deploy application
capistrano 'alm' do
  action          [:config, :bundle_install, :precompile_assets, :migrate, :restart]
end
