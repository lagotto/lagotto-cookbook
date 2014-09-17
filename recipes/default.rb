# install and configure dependencies
include_recipe "couchdb"
include_recipe "memcached"
include_recipe "postfix"

# install mysql and create configuration file and database
mysql_rails 'lagotto' do
  action          [:config, :setup]
end

# create CouchDB database
bash "create CouchDB database" do
  code            "curl -X PUT #{node['lagotto']['couchdb']['url']}"
  returns         [0, 127]
end

# install nginx and create configuration file and application root
passenger_nginx 'lagotto' do
  action          :config
end

# create configuration files
capistrano_template 'config/settings.yml' do
  source          'settings.yml.erb'
  application     'lagotto'
  params          node['lagotto']['settings']
end

capistrano_template 'db/seeds/_custom_sources.rb' do
  source          '_custom_sources.rb.erb'
  application     'lagotto'
  params          node['lagotto']['sources']
end

# create required files and folders, and deploy application
capistrano 'lagotto' do
  action          [:config, :bundle_install, :precompile_assets, :migrate, :restart]
end
