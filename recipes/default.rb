# install and configure dependencies
include_recipe "apt"
include_recipe "couchdb"
include_recipe "memcached"
include_recipe "postfix"
include_recipe "phantomjs"

# install mysql and create configuration file and database
mysql_rails 'lagotto' do
  action          :create
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
capistrano_template 'config/application.yml' do
  source          'application.yml.erb'
  application     'lagotto'
  params          node['lagotto']['application']
end

# create required files and folders, and deploy application
capistrano 'lagotto' do
  action          [:config, :bundle_install, :precompile_assets, :migrate, :restart]
end
