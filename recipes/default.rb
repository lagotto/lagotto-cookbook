case node['platform']
when "ubuntu"
  # Install required packages
  %w{ruby1.9.3 curl}.each do |pkg|
    package pkg do
      action :install
    end
  end
  gem_package "bundler" do
    gem_binary "/usr/bin/gem"
  end
when "centos"
  yum_package "urw-fonts"
end

# Create new settings.yml
require 'securerandom'
# Set these passwords in config.json to keep them persistent
node.set_unless['alm']['key'] = SecureRandom.hex(30)
node.set_unless['alm']['secret'] = SecureRandom.hex(30)
node.set_unless['alm']['api_key'] = SecureRandom.hex(10)
template "/vagrant/config/settings.yml" do
  source 'settings.yml.erb'
  owner 'root'
  group 'root'
  mode 0644
end

# Create new database.yml
# Set these passwords in config.json to keep them persistent
node.set_unless['mysql']['server_root_password'] = SecureRandom.hex(8)
node.set_unless['mysql']['server_repl_password'] = SecureRandom.hex(8)
node.set_unless['mysql']['server_debian_password'] = SecureRandom.hex(8)
template "/vagrant/config/database.yml" do
  source 'database.yml.erb'
  owner 'root'
  group 'root'
  mode 0644
end

include_recipe "mysql::server"

# Seed the database with sources, groups and sample articles
template "/vagrant/db/seeds.rb" do
  source 'seeds.rb.erb'
  owner 'root'
  group 'root'
  mode 0644
end

# Install required gems via bundler
script "bundle" do
  interpreter "bash"
  cwd "/vagrant"
  code "bundle install"
end

case node['platform']
when "centos"
  # required by Cucumber tests
  gem_package "faye-websocket" do
    version "0.4.7"
  end
end

# Create default databases and run migrations
script "RAILS_ENV=#{node[:alm][:environment]} rake db:setup" do
  interpreter "bash"
  cwd "/vagrant"
  if node[:alm][:seed_sample_articles]
    code "RAILS_ENV=#{node[:alm][:environment]} rake db:setup ARTICLES='1'"
  else
    code "RAILS_ENV=#{node[:alm][:environment]} rake db:setup"
  end
end

# Create default CouchDB database
script "create CouchDB database #{node[:alm][:name]}" do
  interpreter "bash"
  code "curl -X DELETE http://#{node[:alm][:host]}:#{node[:couch_db][:config][:httpd][:port]}/#{node[:alm][:name]}/"
  code "curl -X PUT http://#{node[:alm][:host]}:#{node[:couch_db][:config][:httpd][:port]}/#{node[:alm][:name]}/"
  ignore_failure true
end

# Generate new Procfile
template "/vagrant/Procfile" do
  source 'Procfile.erb'
  owner 'root'
  group 'root'
  mode 0644
end

case node['platform']
when "ubuntu"
  node.set_unless['passenger']['root_path'] = "/var/lib/gems/1.9.1/gems/passenger-#{node['passenger']['version']}"
  node.set_unless['passenger']['module_path'] = "/var/lib/gems/1.9.1/gems/passenger-#{node['passenger']['version']}/ext/apache2/mod_passenger.so"
  include_recipe "passenger_apache2::mod_rails"

  execute "disable-default-site" do
    command "sudo a2dissite default"
  end

  web_app "alm" do
    template "alm.conf.erb"
    notifies :reload, resources(:service => "apache2"), :delayed
  end
when "centos"
  template "/etc/httpd/conf.d/alm.conf" do
    source 'alm.conf.erb'
    owner 'root'
    group 'root'
    mode 0644
  end

  # Allow all traffic on the loopback device
  simple_iptables_rule "system" do
    rule "--in-interface lo"
    jump "ACCEPT"
  end

  # Allow HTTP
  simple_iptables_rule "http" do
    rule "--proto tcp --dport 80"
    jump "ACCEPT"
  end

  # Allow CouchDB
  simple_iptables_rule "couchdb" do
    rule "--proto tcp --dport 5984"
    jump "ACCEPT"
  end

  script "start httpd" do
    interpreter "bash"
    code "sudo /sbin/service httpd start"
  end
end
