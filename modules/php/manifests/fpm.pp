# Install PHP-FPM
# @param version Version to install
class php::fpm (
  String $version = '8.4'
) {
  include base::base

  exec { 'download-fpm-apt-key':
    command => 'wget -O /usr/share/keyrings/sury-keyring.gpg https://packages.sury.org/php/apt.gpg',
    path    => '/usr/bin',
    creates => '/usr/share/keyrings/sury-keyring.gpg',
    require => [
      Package['wget']
    ],
  }

  apt::source { 'sury-php':
    comment  => 'Sury PHP Packages',
    location => 'http://packages.sury.org/php/',
    release  => 'bookworm',
    repos    => 'main',
    keyring  => '/usr/share/keyrings/sury-keyring.gpg',
    include  => {
      'src' => false,
      'deb' => true,
    },
    require  => [
      Exec['download-fpm-apt-key']
    ],
  }
}
