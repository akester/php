class { 'php::fpm':
  version => '8.5',
}

include ssh::ssh
