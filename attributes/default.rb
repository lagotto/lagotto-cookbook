default['ruby']['packages'] = %w{ curl git libmysqlclient-dev python-software-properties software-properties-common }
default['ruby']['packages'] += %w{ avahi-daemon libnss-mdns } if ENV['RAILS_ENV'] != "production"
default["dotenv"] = "default"
default["application"] = "lagotto"
default['ruby']['merge_slashes_off'] = true
default['ruby']['api_only'] = false
default['couch_db']['config']['httpd']['bind_address'] = "0.0.0.0" if ENV['RAILS_ENV'] != "production"
#default['nodejs']['install_method'] = "binary"
default['nodejs']['version'] = "0.12.0"
# default['nodejs']['binary']['checksum']['linux_x64'] = "305bf2983c65edea6dd2c9f3669b956251af03523d31cf0a0471504fd5920aac"
default['nodejs']['npm']['version'] = "2.7.5"
default['nodejs']['npm_packages'] = [{ "name" => "phantomjs" },
                                     { "name" => "istanbul"},
                                     { "name" => "codeclimate-test-reporter" }]
default['consul']['servers'] = ENV['CONSUL_SERVERS'] || [ENV['HOSTNAME']]
default['consul']['service_mode'] = 'cluster'
