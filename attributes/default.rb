default['ruby']['packages'] = %w{ curl git libmysqlclient-dev libpq-dev avahi-daemon libnss-mdns python-software-properties software-properties-common }
default['nodejs']['npm_packages'] = [{ "name" => "bower" },
                                     { "name" => "ember-cli" },
                                     { "name" => "phantomjs" }]
default["dotenv"] = "default"
default["application"] = "lagotto"
default['ruby']['api_only'] = true
