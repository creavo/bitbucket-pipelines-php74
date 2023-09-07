# Bitbucket Pipelines PHP 7.4 image

[![](https://images.microbadger.com/badges/version/creavo/bitbucket-pipelines-php74.svg)](https://microbadger.com/images/creavo/bitbucket-pipelines-php74 "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/creavo/bitbucket-pipelines-php74.svg)](https://microbadger.com/images/creavo/bitbucket-pipelines-php74 "Get your own image badge on microbadger.com")

## Based on Ubuntu 20.04

### Packages installed

- `php7.4-zip`, `php7.4-xml`, `php7.4-mbstring`, `php7.4-curl`, `php7.4-json`, `php7.4-imap`, `php7.4-mysql`, `php7.4-tokenizer`, `php7.4-xdebug`, `php7.4-intl`, `php7.4-soap`, `php7.4-pdo`, `php7.4-cli`, `php7.4-gd`, `php7.4-gmp` and `php-imagick`
- wget, curl, unzip
- Composer 2
- Mysql 5.7
- Redis-Server
- NPM
- Node + Yarn

### Sample `bitbucket-pipelines.yml`

```YAML
image: creavo/bitbucket-pipelines-php74
pipelines:
  default:
    - step:
        script:
          - composer self-update
          - phive self-update
          - service mysql start
          - mysql -h localhost -u root -proot -e "CREATE DATABASE test;"
          - composer install --no-interaction --no-progress --prefer-dist
          - ./vendor/phpunit/phpunit/phpunit -v --coverage-text --colors=never --stderr
```
