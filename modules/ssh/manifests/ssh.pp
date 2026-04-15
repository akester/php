# For SSH access containers, this configures a basic SSH server
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

  # This is our entrypoint script
  file { '/ssh.sh':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/ssh/ssh.sh',
  }

  # Extra tools for SSH debugging
  $packages = [
    'redis-tools',
  ]
  package { $packages:
    ensure  => 'present',
  }
}
