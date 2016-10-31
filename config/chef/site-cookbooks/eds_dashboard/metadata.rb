name             'eds_dashboard'
maintainer       'Berea College'
maintainer_email 'stoebelj@berea.edu'
license          'All rights reserved'
description      'Installs/Configures eds_dashboard'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'mysql', '~> 7.0'
depends 'mysql2_chef_gem', '~> 1.1'
depends 'httpd', '~> 0.4'
depends 'database', '~> 5.1'
