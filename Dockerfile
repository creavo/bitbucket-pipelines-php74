FROM ubuntu:20.04

MAINTAINER Creavo <info@creavo.de>

# Set environment variables
ENV HOME /root

# MySQL root password
ARG MYSQL_ROOT_PASS=root

# Cloudflare DNS
RUN echo "nameserver 1.1.1.1" | tee /etc/resolv.conf > /dev/null

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
    openssl \
    ssh \
    locales \
    less \
    sudo \
    mysql-server \
    redis-server \
    npm

# add yarn-dependency
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    yarn \
    php-pear php7.4-mysql php7.4-zip php7.4-xml php7.4-mbstring php7.4-curl php7.4-json php7.4-pdo php7.4-tokenizer php7.4-cli php7.4-imap php7.4-intl php7.4-gd php7.4-xdebug php7.4-soap php7.4-gmp php-imagick \
    apache2 libapache2-mod-php7.4 \
    --no-install-recommends

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install phive
RUN wget -O phive.phar "https://phar.io/releases/phive.phar" && \
    wget -O phive.phar.asc "https://phar.io/releases/phive.phar.asc" && \
    gpg --keyserver hkps.pool.sks-keyservers.net --recv-keys 0x9D8A98B29B2D5D79 && \
    gpg --verify phive.phar.asc phive.phar && \
    rm phive.phar.asc && \
    chmod +x phive.phar && \
    mv phive.phar /usr/local/bin/phive

# final clean up
RUN DEBIAN_FRONTEND=noninteractive apt-get clean -y && \
    DEBIAN_FRONTEND=noninteractive apt-get autoremove -y && \
    DEBIAN_FRONTEND=noninteractive apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/lib/mysql/ib_logfile*

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
