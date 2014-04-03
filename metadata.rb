name             'jpetstore'
maintainer       'Charles Johnson'
maintainer_email 'charles@opsocde.com'
license          'Apache 2.0'
description      'Installs/configures jpetstore'
version          '0.1.0'
recipe           'jpetstore::default', 'Installs/configures jpetstore'

depends 'tcserver'
depends 'mysql', '~> 5.0.2'
depends 'mysql-chef_gem'
depends 'database', '~> 2.1.2'
depends 'simple_iptables'
