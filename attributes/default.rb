default[:alm][:name] = "alm"
default[:alm][:host] = "127.0.0.1"
default[:alm][:environment] = "development"
default[:alm][:useragent] = "Article-Level Metrics"
default[:alm][:hostname] = "example.com"
default[:alm][:api_key] = nil
default[:alm][:admin] = { :username => "articlemetrics", :name => "Admin", :email => "admin@example.com", :password => nil }
default[:alm][:mail] = { :address => "localhost", :port => 25, :domain => "localhost", :enable_starttls_auto => true }
default[:alm][:uid] = "doi"
default[:alm][:doi_prefix] = ""
default[:alm][:key] = nil
default[:alm][:secret] = nil
default[:alm][:cas_url] = nil
default[:alm][:github_client_id] = nil
default[:alm][:github_client_secret] = nil
default[:alm][:persona] = true
default[:alm][:user] = "vagrant"
default[:alm][:concurrency] = 1
default[:alm][:seed_sample_articles] = false
default[:couch_db][:config][:httpd][:port] = 5984
