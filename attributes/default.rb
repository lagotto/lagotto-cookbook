default['ruby']['packages'] = %w{ curl git libmysqlclient-dev python-software-properties software-properties-common nodejs }
default['ruby']['packages'] += %w{ avahi-daemon libnss-mdns } if ENV['RAILS_ENV'] != "production"
default["dotenv"] = "default"
default["application"] = "lagotto"
default['ruby']['merge_slashes_off'] = true
default['ruby']['api_only'] = false
default['couch_db']['config']['httpd']['bind_address'] = "0.0.0.0" if ENV['RAILS_ENV'] != "production"
default['nodejs']['install_method'] = "binary"
default['nodejs']['version'] = "0.12.5"
default['nodejs']['binary']['checksum']['linux_x64'] = "d4d7efb9e1370d9563ace338e01f7be31df48cf8e04ad670f54b6eb8a3c54e03"
default['nodejs']['npm']['version'] = "2.7.5"
default['nodejs']['npm_packages'] = [{ "name" => "phantomjs" },
                                     { "name" => "istanbul"},
                                     { "name" => "codeclimate-test-reporter" }]
