set -e -x

source /etc/lsb-release

function apt_get() {
  apt-get -y --force-yes --no-install-recommends "$@"
}

packages="
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
ruby
subversion
unzip
wget
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

apt_get update
apt_get dist-upgrade
apt_get install $packages ubuntu-minimal

apt-get clean

rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/*

