class ssh::ssh {
  package { 'openssh-server':
    ensure => 'present',
  }

  file { '/etc/ssh/sshd_config':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/ssh/sshd_config',
  }
}
