require 'securerandom'

default['ruby']['packages'] = %w{ curl git libmysqlclient-dev libpq-dev nodejs avahi-daemon libnss-mdns }
default['ruby']['user'] = 'vagrant'
default['ruby']['group'] = 'vagrant'
default['ruby']['rails_env'] = "development"
default['ruby']['db'] = { 'username' => 'vagrant', 'password' => SecureRandom.hex(10), 'host' => 'localhost' }

default['phantomjs']['version'] = "1.9.7"
default['phantomjs']['base_url'] = "https://bitbucket.org/ariya/phantomjs/downloads"

default['lagotto']['couchdb'] = { 'url' => 'http://localhost:5984/lagotto' }

default['mail'] = { "address" => "localhost", "port" => 25, "domain" => "localhost" }

# config/settings.yml
default['lagotto']['application'] = {
  "db_username"        => node['ruby']['db']['username'],
  "db_password"        => node['ruby']['db']['password'],
  "db_host"            => node['ruby']['db']['host'],
  "hostname"           => "lagotto.local",
  "web_servers"        => nil,
  "public_server"      => nil,
  "sitename"           => nil,
  "couchdb_host"       => "localhost",
  "admin_email"        => "admin@example.com",
  "workers"            => 3,
  "import"             => nil,
  "uid"                => "doi",
  "api_key"            => SecureRandom.hex(20),
  "auth_site_key"      => SecureRandom.hex(34),
  "secret_token"       => SecureRandom.hex(34),
  "persona"            => true,
  "cas_url"            => "https://example.org",
  "cas_prefix"         => "/cas",
  "mail_address"       => node['mail']['address'],
  "mail_port"          => node['mail']['port'],
  "mail_domain"        => node['mail']['domain']
}
