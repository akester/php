class { 'php::fpm':
  version => '8.3',
}

include ssh::ssh
