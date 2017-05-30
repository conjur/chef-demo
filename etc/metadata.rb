name             'phpapp'
maintainer       'CyberArk'
maintainer_email 'foo@bar.com'
license          'All rights reserved'
description      'Installs/Configures phpapp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apache2"
depends "conjur"
depends "conjur-host-identity"
