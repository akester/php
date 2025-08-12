# PHP

This is a fairly opinionated PHP-FPM docker container that is built for my
environment.   It has a number of assumptions built in so I don't have to
overwrite lots of code:

* Everything runs as a user with a UID and GID of 5000
* Logs go to /var/log/app
* It's a small site, so only 10 workers are allowed max.

Each supported version of PHP is built, and they are all tagged as such, for
example `akester/php:8.4`.

## SSH

These containers also are built in an SSH variant that includes all the usual
PHP stuff _and_ OpenSSH Server.  The idea here is to give a shell for remote CI
to connect to that has the same PHP Environment for automated code deployments,
clearing caches, or manual troubleshooting.

To use one of those, use `akester/php:8.4-ssh` and provide a public key(s) that
should be allowed in via the `SSH_AUTHORIZED_KEYS` variable.  This will be
written to an authorized keys file for the non-root user to allow access.  I
recommend using some proxy in front of this set up, such as SSH Piper or the
like.

These are kept in separate containers so that the main application container
doesn't have the extra components installed and hopefully reduce any attack
surface within the container.

## Building

This container is built using Packer.  Running `make` will build all the images,
or `make build-all` to build them all at the same time.  You can also do `make
only-8.4` to build only version 8.4, for example.

The work in the container is done via Puppet.  This is overkill, but simplifies
a number of operations and ordering.  Add things to the manifests to get them
built in the containers.

Each version has a starter manifest, `8.4.pp` and then calls a module to do the
actual installation.

## Mirror

If you're looking at this repo at https://github.com/akester/php/, know
that it's a mirror of my local code repository.  This repo is monitored though,
so any pull requests or issues will be seen.
