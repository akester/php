# Common base things required
class base::base {
  group { 'web':
    ensure => 'present',
    gid    => '5000',
  }
  ->user { 'web':
    ensure     => 'present',
    managehome => true,
    shell      => '/bin/bash',
    uid        => '5000',
    gid        => '5000',
  }

  # Install our required packages
  $packages = [
    'bash',
    'wget',
    'gnupg2',

    # In case we jump into a pod to troubleshoot
    'vim',
    'nano',
    'strace',

    # Other tools for crons and external work
    'curl',
    'htop',
    'rsync',
    'dnsutils',
    'inetutils-ping',
    'host',
    'net-tools',
    'less',
    'git',
  ]
  package { $packages:
    ensure => 'present',
  }
}
