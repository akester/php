source "docker" "php8-1" {
  commit = true
  image  = "debian:12"
  changes = [
    "CMD [\"/start.sh\"]"
  ]
}

source "docker" "php8-2" {
  commit = true
  image  = "debian:12"
  changes = [
    "CMD [\"/start.sh\"]"
  ]
}

source "docker" "php8-3" {
  commit = true
  image  = "debian:12"
  changes = [
    "CMD [\"/start.sh\"]"
  ]
}

source "docker" "php8-4" {
  commit = true
  image  = "debian:12"
  changes = [
    "CMD [\"/start.sh\"]"
  ]
}

####
# 8.1
####
build {
  sources = [
    "source.docker.php8-1",
    "source.docker.php8-2",
    "source.docker.php8-3",
    "source.docker.php8-4",
  ]

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "DEBIAN_PRIORITY=critical"
    ]
    inline = [
      "set -e",
      "set -x",

      // "echo 'Acquire::http::proxy \"http://cache.kester.cloud:3142\";' | tee /etc/apt/apt.conf.d/01proxy",

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

      "puppet apply /opt/provision/8.1.pp --modulepath=/opt/provision/.modules:/opt/provision/modules"
    ]

    only           = ["docker.php8-1"]
    inline_shebang = "/bin/bash -e"
  }
  provisioner "shell" {
    inline = [
      "set -e",
      "set -x",

      "puppet apply /opt/provision/8.2.pp --modulepath=/opt/provision/.modules:/opt/provision/modules"
    ]

    only           = ["docker.php8-2"]
    inline_shebang = "/bin/bash -e"
  }
  provisioner "shell" {
    inline = [
      "set -e",
      "set -x",

      "puppet apply /opt/provision/8.3.pp --modulepath=/opt/provision/.modules:/opt/provision/modules"
    ]

    only           = ["docker.php8-3"]
    inline_shebang = "/bin/bash -e"
  }
  provisioner "shell" {
    inline = [
      "set -e",
      "set -x",

      "puppet apply /opt/provision/8.4.pp --modulepath=/opt/provision/.modules:/opt/provision/modules"
    ]

    only           = ["docker.php8-4"]
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

      "rm -f /etc/apt/apt.conf.d/01proxy",
      "apt-get update",

      # Clean up stuff that gets left behind
      "rm -rf /var/cache/puppet/state",

      # Clean up caches on the system
      "apt-get remote -y puppet"
      "apt-get clean",
      "apt-get autoclean",
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
      "8.1"
    ]

    only = ["docker.php8-1"]
  }
  post-processor "docker-tag" {
    repository = "akester/php"
    tags = [
      "8.2"
    ]

    only = ["docker.php8-2"]
  }
  post-processor "docker-tag" {
    repository = "akester/php"
    tags = [
      "8.3"
    ]

    only = ["docker.php8-3"]
  }
  post-processor "docker-tag" {
    repository = "akester/php"
    tags = [
      "8.4"
    ]

    only = ["docker.php8-4"]
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