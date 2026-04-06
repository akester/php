class { 'php::fpm':
  version => '8.1',
}

include ssh::ssh
