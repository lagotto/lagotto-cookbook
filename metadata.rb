name              "lagotto"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@plos.org"
license           "Apache 2.0"
description       "Install and configure the Lagotto application"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "4.0.5"

# opscode cookbooks
depends           "apt"
depends           "memcached"
depends           "postfix"
depends           "mysql", '~> 5.4.3'
depends           "database"
depends           "couchdb"

# our own cookbooks
depends           "ruby", "~> 0.6.0"
depends           "ember_cli", "~> 0.1.0"
depends           "dotenv", "~> 0.1.0"
depends           "passenger_nginx", "~> 0.3.0"
depends           "mysql_rails", "~> 0.3.0"
depends           "capistrano", "~> 0.7.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
