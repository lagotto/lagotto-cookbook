default['ruby']['packages'] = %w{ curl git libmysqlclient-dev libpq-dev avahi-daemon libnss-mdns python-software-properties software-properties-common }
default['nodejs']['npm_packages'] = [{ "name" => "bower" },
                                     { "name" => "ember-cli" },
                                     { "name" => "phantomjs" }]
default["dotenv"] = "default"
default["application"] = "lagotto"
default['ruby']['merge_slashes_off'] = true
default['ruby']['api_only'] = false
default['couch_db']['config']['httpd']['bind_address'] = "0.0.0.0" if ENV['RAILS_ENV'] != "production"
