require 'securerandom'

default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs libpq-dev }
default['ruby']['user'] = 'vagrant'
default['ruby']['group'] = 'www-data'
default['ruby']['rails_env'] = "production"
default['ruby']['db'] = { 'username' => 'vagrant', 'password' => SecureRandom.hex(10), 'host' => 'localhost' }

default['alm']['couchdb'] = { 'url' => 'http://localhost:5984/alm' }

# config/settings.yml
default['alm']['settings'] = {
  "useragent"          => "Article-Level Metrics",
  "notification_email" => "admin@example.com",
  "api_key"            => SecureRandom.hex(20),
  "uid"                => "doi",
  "doi_prefix"         => "",
  "rest_auth_site_key" => SecureRandom.hex(34),
  "secret_token"       => SecureRandom.hex(34),
  "persona"            => true,
  "cas_url"            => "https://example.org",
  "cas_prefix"         => "/cas",
  "workers"            => 3,
  "couchdb_url"        => node['alm']['couchdb']['url'],
  "mail"               => { address: "localhost", port: 25, domain: "localhost", enable_starttls_auto: true }
}

# db/seeds/_custom_sources.rb
default['alm']['sources'] = {
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

