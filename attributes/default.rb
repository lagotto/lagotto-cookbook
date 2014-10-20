default['ruby']['packages'] = %w{ curl git libmysqlclient-dev libpq-dev nodejs avahi-daemon libnss-mdns }
default['ruby']['user'] = ENV['USER']
default['ruby']['group'] = ENV['GROUP']
default['ruby']['rails_env'] = ENV['RAILS_ENV']
default['ruby']['db'] = { 'username' => ENV['DB_USER'], 'password' => ENV['DB_PASSWORD'], 'host' => ENV['DB_HOST'] }

default['phantomjs']['version'] = "1.9.7"
default['phantomjs']['base_url'] = "https://bitbucket.org/ariya/phantomjs/downloads"

default['lagotto']['couchdb_url'] = "http://#{ENV['COUCHDB_HOST']}:5984/lagotto"
