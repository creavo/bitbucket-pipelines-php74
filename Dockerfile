FROM ubuntu:20.04

MAINTAINER Creavo <info@creavo.de>

# Set environment variables
ENV HOME /root

# MySQL root password
ARG MYSQL_ROOT_PASS=root

# Cloudflare DNS, removed since docker does not allow changes of /etc/hosts and /etc/resolv.conf
#RUN echo "nameserver 1.1.1.1" | tee /etc/resolv.conf > /dev/null

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git \
    mcrypt \
    unzip \
    wget \
    curl \
    gnupg \
    openssl \
    ssh \
    locales \
    less \
    sudo \
    mysql-server \
    redis-server

# add node-dependency
RUN mkdir -p /etc/apt/keyrings && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_16.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# add yarn-dependency
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    yarn \
    nodejs \
    php-pear php7.4-mysql php7.4-zip php7.4-xml php7.4-mbstring php7.4-curl php7.4-json php7.4-pdo php7.4-tokenizer php7.4-cli php7.4-imap php7.4-intl php7.4-gd php7.4-xdebug php7.4-soap php7.4-gmp php-imagick \
    apache2 libapache2-mod-php7.4 \
    --no-install-recommends

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# final clean up
RUN DEBIAN_FRONTEND=noninteractive apt-get clean -y && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    DEBIAN_FRONTEND=noninteractive apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN systemctl start redis-server && \
#     systemctl enable redis-server

# Ensure UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Timezone & memory limit
RUN echo "date.timezone=Europe/Berlin" > /etc/php/7.4/cli/conf.d/date_timezone.ini && echo "memory_limit=1G" >> /etc/php/7.4/apache2/php.ini

# Goto temporary directory.
WORKDIR /tmp
