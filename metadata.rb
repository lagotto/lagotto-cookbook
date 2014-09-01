name              "alm"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Install and configure ALM application"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "3.3.2"

# opscode cookbooks
depends           "apt"
depends           "memcached"
depends           "postfix"
depends           "phantomjs", "~> 1.0.3"
depends           "mysql", '~> 5.4.3'
depends           "database"
depends           "couchdb"

# our own cookbooks
depends           "ruby", "~> 0.2.0"
depends           "passenger_nginx", "~> 0.2.0"
depends           "mysql_rails", "~> 0.1.0"
depends           "capistrano", "~> 0.5.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
