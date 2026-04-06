class { 'php::fpm':
  version => '8.2',
}

include ssh::ssh
