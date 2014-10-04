require 'securerandom'

default['ruby']['packages'] = %w{ curl git libmysqlclient-dev libpq-dev nodejs avahi-daemon libnss-mdns }
default['ruby']['user'] = 'vagrant'
default['ruby']['group'] = 'vagrant'
default['ruby']['rails_env'] = "development"
default['ruby']['db'] = { 'username' => 'vagrant', 'password' => SecureRandom.hex(10), 'host' => 'localhost' }

default['phantomjs']['version'] = "1.9.7"
default['phantomjs']['base_url'] = "https://bitbucket.org/ariya/phantomjs/downloads"

default['lagotto']['couchdb'] = { 'url' => 'http://localhost:5984/lagotto' }

# config/settings.yml
default['lagotto']['settings'] = {
  "useragent"          => "Lagotto",
  "notification_email" => "admin@example.com",
  "api_key"            => SecureRandom.hex(20),
  "uid"                => "doi",
  "import"             => nil,
  "rest_auth_site_key" => SecureRandom.hex(34),
  "secret_token"       => SecureRandom.hex(34),
  "persona"            => true,
  "cas_url"            => "https://example.org",
  "cas_prefix"         => "/cas",
  "workers"            => 3,
  "couchdb_url"        => node['lagotto']['couchdb']['url'],
  "mail"               => { address: "localhost", port: 25, domain: "localhost", enable_starttls_auto: true }
}

# db/seeds/_custom_sources.rb
default['lagotto']['sources'] = {
  "counter"          => { url: nil },
  "mendeley"         => { client_id: nil, secret: nil },
  "pmc"              => { url: nil, journals: nil, username: nil, password: nil },
  "f1000"            => {},
  "facebook"         => { access_token: nil },
  "twitter_search"   => { access_token: nil },
  "crossref"         => { username: nil, password: nil },
  "researchblogging" => { username: nil, password: nil },
  "scopus"           => { api_key: nil, insttoken: nil },
  "copernicus"       => {},
  "admin"            => { username: "articlemetrics", name: "Admin", email: "admin@example.com", password: nil }
}

