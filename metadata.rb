name              "alm"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Install and configure ALM application"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "3.0.0"
depends           "memcached"
depends           "postfix"
depends           "phantomjs"
depends           "mysql"
depends           "database"
depends           "couchdb"
depends           "passenger_nginx", "~> 0.1.0"
depends           "capistrano", "~> 0.1.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
