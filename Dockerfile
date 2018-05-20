ARG base
FROM $base
ARG arch
ARG locales
ARG packages
ARG package_args='--allow-downgrades --allow-remove-essential --allow-change-held-packages --no-install-recommends'

COPY arch/$arch/sources.list /etc/apt/sources.list

# TODO: keep /usr/share/doc/*/copyright
RUN echo "debconf debconf/frontend select noninteractive" | debconf-set-selections && \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get -y $package_args update && \
  apt-get -y $package_args dist-upgrade && \
  apt-get -y $package_args install $packages && \
  apt-get clean && \
  rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/groff/* /usr/share/info/* /usr/share/lintian/* /usr/share/linda/* /tmp/*

# TODO: determine if tzdata and libc6 regen is necessary
RUN echo 'LANG="en_US.UTF-8"' > /etc/default/locale && \
  echo "$locales" | grep -f - /usr/share/i18n/SUPPORTED | cut -d " " -f 1 | xargs locale-gen && \
  dpkg-reconfigure -fnoninteractive -pcritical locales tzdata libc6

# TODO: determine if we need this, ask Julz
RUN mkdir -p /var/vcap/sys/cores && \
  chmod ugo+rwx /var/vcap/sys/cores

RUN useradd -u 2000 -mU -s /bin/bash vcap && \
  mkdir /home/vcap/app && \
  chown vcap:vcap /home/vcap/app && \
  ln -s /home/vcap/app /app

USER vcap
