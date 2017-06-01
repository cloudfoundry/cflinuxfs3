set -e -x

source /etc/lsb-release

function apt_get() {
  apt-get -y --allow-downgrades --allow-remove-essential --allow-change-held-packages --no-install-recommends "$@"
}

export DEBIAN_FRONTEND=noninteractive

packages="
ubuntu-minimal

autoconf
build-essential
bzr
cmake
cron
curl
git-core
imagemagick
jq
less
libcap2-bin
libcurl3-dev
libfreetype6
libicu-dev
liblzma-dev
libmariadb-client-lgpl-dev
libpq-dev
libsasl2-dev
libsqlite3-dev
libxml2-dev
libxslt1-dev
mercurial
pkg-config
python
rsync
subversion
unzip
wget

ruby
"

if [ "`uname -m`" == "ppc64le" ]; then
packages=$(sed '/\b\(libopenblas-dev\|libdrm-intel1\|dmidecode\)\b/d' <<< "${packages}")
ubuntu_url="http://ports.ubuntu.com/ubuntu-ports"
else
ubuntu_url="http://archive.ubuntu.com/ubuntu"
fi

cat > /etc/apt/sources.list <<EOS
deb $ubuntu_url $DISTRIB_CODENAME main universe multiverse
deb $ubuntu_url $DISTRIB_CODENAME-updates main universe multiverse
deb $ubuntu_url $DISTRIB_CODENAME-security main universe multiverse
EOS

# install gpgv so we can update
apt_get install gpgv
apt_get update
apt_get dist-upgrade
apt_get install $packages
apt-get clean

rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/*

