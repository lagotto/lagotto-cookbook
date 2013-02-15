require 'securerandom'

# Create new database.yml
template "/vagrant/config/database.yml" do
  source 'database.yml.erb'
  owner 'root'
  group 'root'
  mode 0644
end

# Create new settings.yml
node.set_unless['app']['key'] = SecureRandom.hex(30)
node.set_unless['app']['secret'] = SecureRandom.hex(30)
template "/vagrant/config/settings.yml" do
  source 'settings.yml.erb'
  owner 'root'
  group 'root'
  mode 0644
end

# install CouchDB if we didn't include the cookbook
unless node['couch_db']['install_erlang']
  package "couchdb" do
    action :install
  end
  
  service "couchdb" do
    if platform_family?("rhel","fedora")
      start_command "/sbin/service couchdb start &> /dev/null"
      stop_command "/sbin/service couchdb stop &> /dev/null"
    end
    supports [ :restart, :status ]
    action [ :enable, :start ]
  end
end

# Create default CouchDB database
execute "create CouchDB database #{node[:couchdb][:database]}" do
  command "curl -X DELETE http://#{node[:couchdb][:host]}:#{node[:couchdb][:port]}/#{node[:couchdb][:database]}/"
  command "curl -X PUT http://#{node[:couchdb][:host]}:#{node[:couchdb][:port]}/#{node[:couchdb][:database]}/"
  ignore_failure true
end

# Optionally seed the database with sources, groups and sample articles
template "/vagrant/db/seeds/sources.seeds.erb" do
  source 'sources.seeds.erb'
  owner 'root'
  group 'root'
  mode 0644
end

# Run bundle command
script "bundle" do
  interpreter "bash"
  cwd "/vagrant"
  code "bundle install"
end

# Create default databases and run migrations
script "rake db:setup RAILS_ENV=#{node[:rails][:environment]}" do
  interpreter "bash"
  cwd "/vagrant"
  code "rake db:setup RAILS_ENV=#{node[:rails][:environment]}"
end

# Generate new Procfile
template "/vagrant/Procfile" do
  source 'Procfile.erb'
  owner 'root'
  group 'root'
  mode 0644
end


case node[:platform]
#when "centos","redhat","fedora","suse"
when "debian","ubuntu"
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