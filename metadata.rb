name              "lagotto"
maintainer        "Martin Fenner"
maintainer_email  "mfenner@datacite.org"
license           "Apache 2.0"
description       "Install and configure the Lagotto application"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "5.0.5"

# opscode cookbooks
depends           "apt"
depends           "memcached"
depends           "postfix"
depends           "nodejs"
depends           "consul"
depends           "rsyslog"

# our own cookbooks
depends           "ruby", "~> 0.7.0"
depends           "dotenv", "~> 1.0.0"
depends           "passenger_nginx", "~> 1.0.0"
depends           "capistrano", "~> 1.0.0"

%w{ ubuntu }.each do |platform|
  supports platform
end
