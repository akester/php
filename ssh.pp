class { 'php::fpm':
  version => '8.4',
}

include ssh::ssh
