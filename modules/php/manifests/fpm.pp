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

  package { "php${version}-fpm":
    ensure  => 'present',
    require => [
      Apt::Source['sury-php']
    ],
  }

  $packages = [
    "php${version}",
    "php${version}-mysql",
    "php${version}-opcache",
    "php${version}-cli",
    "php${version}-gd",
    "php${version}-mbstring",
    "php${version}-zip",
    "php${version}-curl",
    "php${version}-xml",
    "php${version}-bcmath",
    "php${version}-gmp",
    "php${version}-common",
    "php${version}-sqlite",
    "php${version}-intl",
    'php-pear',
  ]
  package { $packages:
    ensure  => 'present',
    require => [
      Package["php${version}-fpm"]
    ],
  }

  $other_packages = [
    'python3',
    'python3-requests',
    'python3-dotenv',
    'python3-praw',
  ]
  package { $other_packages:
    ensure  => 'present',
  }
}
