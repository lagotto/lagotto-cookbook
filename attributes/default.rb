require 'securerandom'

default['alm']['name'] = "alm"
default['alm']['rails_env'] = "development"
default['alm']['web'] = { 'default_server' => true }
default['alm']['db'] = { 'user' => 'root', 'password' => node['mysql']['server_root_password'], 'host' => '127.0.0.1' }
default['alm']['couchdb'] = { 'url' => 'http://127.0.0.1:5984/alm' }


default['alm']['settings'] = {}

default['alm']['useragent'] = "Article-Level Metrics"
default['alm']['api_key'] = SecureRandom.hex(20)
default['alm']['admin'] = { username: "articlemetrics", name: "Admin", email: "admin@example.com", password: nil }
default['alm']['mail'] = { address: "localhost", port: 25, domain: "localhost", enable_starttls_auto: true }
default['alm']['uid'] = "doi"
default['alm']['doi_prefix'] = ""
default['alm']['key'] = SecureRandom.hex(30)
default['alm']['secret'] = SecureRandom.hex(30)
default['alm']['persona'] = true
default['alm']['cas_url'] = "https://example.org"
default['alm']['cas_prefix'] = "/cas"
default['alm']['workers'] = 3
default['alm']['counter'] = { url: nil }
default['alm']['mendeley'] = { client_id: nil, secret: nil }
default['alm']['pmc'] = { url: nil, journals: nil, username: nil, password: nil }
default['alm']['f1000'] = {}
default['alm']['facebook'] = { access_token: nil }
default['alm']['twitter_search'] = { access_token: nil }
default['alm']['crossref'] = { username: nil, password: nil }
default['alm']['copernicus'] = { url: nil, username: nil, password: nil }
default['alm']['researchblogging'] = { username: nil, password: nil }
default['alm']['scopus'] = { api_key: nil, insttoken: nil }

default['user'] = 'vagrant'
default['ruby']['packages'] = %w{ libxml2-dev libxslt-dev libmysqlclient-dev nodejs libpq-dev }
