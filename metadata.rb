name              "lagotto"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Install and configure the Lagotto application"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "3.5.0"

# opscode cookbooks
depends           "apt"
depends           "memcached"
depends           "postfix"
depends           "phantomjs"
depends           "mysql", '~> 5.4.3'
depends           "database"
depends           "couchdb"

# our own cookbooks
depends           "ruby", "~> 0.3.0"
depends           "passenger_nginx", "~> 0.2.0"
depends           "mysql_rails", "~> 0.3.0"
depends           "capistrano", "~> 0.6.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
