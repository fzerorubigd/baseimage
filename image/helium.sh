#!/usr/bin/env bash
set -euo pipefail
source /bd_build/buildconfig

apt-get update
$minimal_apt_get_install git zsh nano libsqlite3-dev autoconf bison build-essential libssl-dev \
                libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev htop redis-server postgresql mercurial \
                ruby-dev rabbitmq-server realpath pkg-config unzip dnsutils re2c python-pip \
                python-dev libpq-dev tmux bzr libsodium-dev cmake default-jdk golang

