if node['platform'] == "ubuntu"
  # Install required packages
  %w{ruby1.9.3 libxslt-dev libxml2-dev ruby-bundler curl}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

# Install required gems via bundler
script "bundle" do
  interpreter "bash"
  cwd "/vagrant"
  code "bundle install"
end

# Create new settings.yml
require 'securerandom'
node.set_unless['app']['key'] = SecureRandom.hex(30)
node.set_unless['app']['secret'] = SecureRandom.hex(30)
template "/vagrant/config/settings.yml" do
  source 'settings.yml.erb'
  owner 'root'
  group 'root'
  mode 0644
end

# Create new database.yml
template "/vagrant/config/database.yml" do
  source 'database.yml.erb'
  owner 'root'
  group 'root'
  mode 0644
end

# Optionally seed the database with sources, groups and sample articles
template "/vagrant/db/seeds/sources.seeds.erb" do
  source 'sources.seeds.erb'
  owner 'root'
  group 'root'
  mode 0644
end

# Create default databases and run migrations
script "rake db:setup RAILS_ENV=#{node[:rails][:environment]}" do
  interpreter "bash"
  cwd "/vagrant"
  code "rake db:setup RAILS_ENV=#{node[:rails][:environment]}"
end

# Create default CouchDB database
script "create CouchDB database #{node[:couchdb][:database]}" do
  interpreter "bash"
  code "curl -X DELETE http://#{node[:couchdb][:host]}:#{node[:couchdb][:port]}/#{node[:couchdb][:database]}/"
  code "curl -X PUT http://#{node[:couchdb][:host]}:#{node[:couchdb][:port]}/#{node[:couchdb][:database]}/"
  ignore_failure true
end

# Generate new Procfile
template "/vagrant/Procfile" do
  source 'Procfile.erb'
  owner 'root'
  group 'root'
  mode 0644
end

case node[:platform]
when "debian","ubuntu"
  include_recipe "passenger_apache2::mod_rails"
  
  execute "disable-default-site" do
    command "sudo a2dissite default"
    notifies :reload, resources(:service => "apache2"), :delayed
  end
end

web_app "alm" do
  docroot "/vagrant/public"
  template "alm.conf.erb"
  notifies :reload, resources(:service => "apache2"), :delayed
end