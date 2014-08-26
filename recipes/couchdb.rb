include_recipe "couchdb::default"

# Create default CouchDB database
script "create CouchDB database #{node[:alm][:name]}" do
  interpreter "bash"
  code "curl -X PUT http://#{node[:alm][:host]}:#{node[:couch_db][:config][:httpd][:port]}/#{node[:alm][:name]}/"
  ignore_failure true
end
