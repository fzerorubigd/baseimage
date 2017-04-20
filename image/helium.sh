#!/usr/bin/env bash
set -euo pipefail
source /bd_build/buildconfig

# Install golang
cd /tmp
curl https://godeb.s3.amazonaws.com/godeb-amd64.tar.gz | gunzip | tar xvf -
/tmp/godeb install 1.8.1

# Add sun-java repo
add-apt-repository ppa:webupd8team/java

# Add cassandra repo
echo "deb http://www.apache.org/dist/cassandra/debian 310x main" > /etc/apt/sources.list.d/cassandra.sources.list
apt-key adv --keyserver pool.sks-keyservers.net --recv-key A278B781FE4B2BDA

# Add elastic search
curl https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
echo "deb https://artifacts.elastic.co/packages/5.x/apt stable main" >/etc/apt/sources.list.d/elastic-5.x.list

# Add node 7, also this do an apt update too
curl -sL https://deb.nodesource.com/setup_7.x | bash -

echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections


$minimal_apt_get_install wget curl sudo git zsh nano libsqlite3-dev autoconf bison build-essential libssl-dev \
                libyaml-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev htop redis-server postgresql mercurial \
                ruby-dev realpath pkg-config unzip dnsutils re2c python-pip oracle-java8-set-default nodejs  \
                python-dev libpq-dev tmux bzr libsodium-dev cmake python-setuptools iputils-ping iproute2 \
                cassandra elasticsearch

GOBIN=/usr/local/bin GOPATH=/tmp go get -v -u github.com/mailhog/MailHog
pip install --upgrade --no-cache-dir pip
pip install --no-cache-dir pgcli


# Create vagrant user
bash -c "echo root:bita123 | chpasswd"
groupadd develop
useradd -g develop -m -s /usr/bin/zsh develop
bash -c "echo %develop ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant"
chmod 0440 /etc/sudoers.d/vagrant
bash -c "echo develop:bita123 | chpasswd"
sudo -Hu develop -- wget -O /home/develop/.zshrc http://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
sudo -Hu develop -- wget -O /home/develop/.zshrc.local  http://git.grml.org/f/grml-etc-core/etc/skel/.zshrc

# Go related stuff
bash -c "echo export GOPATH=/home/develop >> /etc/environment"
sudo -Hu develop -- bash -c "echo export GOPATH=/home/develop >> /home/develop/.zshrc.local"
sudo -Hu develop -- bash -c "echo export PATH=$PATH:/usr/local/go/bin:/home/develop/bin >> /home/develop/.zshrc.local"
