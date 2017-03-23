
FROM ubuntu:16.04
MAINTAINER Conor Heine <conor@conorheine.com>

ENV DEBIAN_FRONTEND noninteractive
ENV TZ America/Los_Angeles
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_TYPE en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Dependencies
RUN apt-get update && apt-get install -y software-properties-common && apt-add-repository ppa:ansible/ansible && apt-get update \
    && apt-get -y install \
    # Core 
        dnsutils \
        ansible \
        fping \
        git \
        graphviz \
        imagemagick \
        libssl-dev \
        smbclient \
        nagios-plugins \
        sendmail \
        mtr-tiny \
        nginx-full \
        nmap \
        python-dev \
        python-mysqldb \
        rrdtool rrdcached \
        libmemcached-dev \
        snmp \
        snmpd \
        wget \
        whois \
    # PHP
        php7.0-cli \
        php7.0-mysql \
        php7.0-gd \
        php7.0-dev \
        php7.0-snmp \
        php-pear \
        php7.0-curl \
        php7.0-fpm \
        php7.0-mcrypt \
        php7.0-json \
        php-net-ipv4 \
        php-net-ipv6 \
    && apt-get -y autoremove --purge && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN chmod u+s /usr/bin/fping /usr/bin/fping6
RUN easy_install supervisor
RUN wget -O /usr/bin/distro https://raw.githubusercontent.com/librenms/librenms-agent/master/snmp/distro && chmod +x /usr/bin/distro

# Configure PHP
RUN phpenmod mcrypt
RUN useradd librenms -d /opt/librenms -M -r && usermod -a -G librenms www-data

# Install LibreNMS
RUN cd /opt && git clone https://github.com/librenms/librenms.git librenms && cd librenms && \
    mkdir rrd logs && \
    cp misc/librenms.logrotate /etc/logrotate.d/librenms && \
    chmod ug+rwx /opt/librenms/rrd && chown -R librenms:www-data /opt/librenms

#Configure container
RUN rm /etc/nginx/sites-enabled/default
COPY config/supervisord.conf /etc/supervisor/supervisord.conf
COPY config/default.conf /etc/nginx/conf.d/
COPY scripts /docker

VOLUME /run/php
VOLUME /opt/librenms/rrd
VOLUME /opt/librenms/logs

WORKDIR /opt/librenms
EXPOSE 80
CMD /docker/entrypoint.sh

