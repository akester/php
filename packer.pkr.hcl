variable "container_version" {
  type    = string
}

variable "php_version" {
  type    = string
}

source "docker" "debian-amd64" {
  commit = true
  image  = "debian:13"
  changes = [
    "CMD [\"/usr/sbin/php-fpm${var.php_version}\", \"-F\"]"
  ]
}

source "docker" "debian-amd64-ssh" {
  commit = true
  image  = "debian:13"
  changes = [
    "CMD [\"/ssh.sh\"]"
  ]
}

source "docker" "debian-arm64" {
  commit = true
  image  = "arm64v8/debian:13"
  changes = [
    "CMD [\"/usr/sbin/php-fpm${var.php_version}\", \"-F\"]"
  ]
}

source "docker" "debian-arm64-ssh" {
  commit = true
  image  = "arm64v8/debian:13"
  changes = [
    "CMD [\"/ssh.sh\"]"
  ]
}

####
# 8.1
####
build {
  sources = [
    "source.docker.debian-amd64",
    "source.docker.debian-amd64-ssh",
    "source.docker.debian-arm64",
    "source.docker.debian-arm64-ssh",
  ]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "DEBIAN_PRIORITY=critical"
    ]
    inline = [
      "set -e",
      "set -x",

      "apt-get update",
      "apt-get -y dist-upgrade",

      "apt-get install -y puppet",
    ]
    inline_shebang = "/bin/bash -e"
  }

  # This replaces the old puppet-masterless method that is no longer maintained.
  provisioner "shell" {
    inline = [
      "set -e",

      "mkdir -p /opt/provision",
    ]
  }
  provisioner "file" {
    source      = "puppet.tar.gz"
    destination = "/opt/provision/"
  }
  provisioner "shell" {
    inline = [
      "set -e",

      "cd /opt/provision && tar -xzvf puppet.tar.gz",
    ]
  }

  ########
  ## Build the specific versions
  ########
  provisioner "shell" {
    inline = [
      "set -e",
      "set -x",

      "puppet apply /opt/provision/php.pp --modulepath=/opt/provision/.modules:/opt/provision/modules"
    ]

    inline_shebang = "/bin/bash -e"
  }

  provisioner "shell" {
    inline = [
      "set -e",
      "set -x",

      "puppet apply /opt/provision/ssh.pp --modulepath=/opt/provision/.modules:/opt/provision/modules"
    ]

    only           = [
      "source.docker.debian-amd64-ssh",
      "source.docker.debian-arm64-ssh",
    ]
    inline_shebang = "/bin/bash -e"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "DEBIAN_PRIORITY=critical"
    ]
    inline = [
      "set -e",
      "set -x",

      # Clean up stuff that gets left behind
      "rm -rf /var/cache/puppet/state",

      # Clean up caches on the system
      "apt-get remove -y puppet",
      "apt-get clean",
      "apt-get autoremove --purge -y",
      "rm -rf /tmp/*",
      "rm -rf /opt/provision",
    ]
    inline_shebang = "/bin/bash -e"
  }

  ########
  ## Tag the specific versions
  ########
  post-processor "docker-tag" {
    repository = "akester/php"
    tags = [
      "${source.name}-${var.container_version}",
    ]

    only = [
      "docker-debian-amd64",
      "docker-debian-arm64",
    ]
  }
  post-processor "docker-tag" {
    repository = "akester/php"
    tags = [
      "${source.name}-${var.container_version}-ssh",
    ]

    only = [
      "docker-debian-amd64-ssh",
      "docker-debian-arm64-ssh",
    ]
  }
}

packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}