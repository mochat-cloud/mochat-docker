# 支持的 tags 以及相应的 Dockerfile 地址

tag 格式:

- 7.4: php 版本, 目前仅支持 7.4
- alpine: base 镜像, 支持 alpine
- v3.11: alpine 版本, 支持  3.9 and 3.10 and 3.11 and 3.12
- swoole: 支持 base/dev/swoole/swow
- v4.5.11: swoole/swow 版本

support:

- [`7.4-alpine-v3.9-swoole-*`, `7.4-alpine-v3.9-swoole`](https://github.com/mochat-cloud/mochat-docker/blob/master/7.4/alpine/swoole/Dockerfile)
- [`7.4-alpine-v3.9-swow-*`, `7.4-alpine-v3.9-swow`](https://github.com/mochat-cloud/mochat-docker/blob/master/7.4/alpine/swow/Dockerfile)
- [`7.4-alpine-v3.9-base`](https://github.com/mochat-cloud/mochat-docker/blob/master/7.4/alpine/base/Dockerfile)

# 参考文档

- [hyperf](https://github.com/hyperf)
- [hyperf doc](https://doc.hyperf.io)

# 如何使用此镜像

将 [Dockerfile](https://github.com/mochat-cloud/mochat-docker/blob/master/Dockerfile) 放到你的项目中.

# 如何build以及推送镜像

```bash
# Build base image
./build.sh build

# Check images
./build.sh publish --check

# Push images
./build.sh publish
```

# 更多演示

- kafka

```dockerfile
RUN apk add --no-cache librdkafka-dev \
&& pecl install rdkafka \
&& echo "extension=rdkafka.so" > /etc/php7/conf.d/rdkafka.ini
```

- mongodb

```dockerfile
RUN apk add --no-cache openssl-dev \
&& pecl install mongodb \
&& echo "extension=mongodb.so" > /etc/php7/conf.d/mongodb.ini
```

- wxwork_finance_sdk

```dockerfile
  ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2 \
  && cd /tmp \
  && curl -SL "https://github.com/oh-stone/wework-chatdata-sdk/archive/v0.1.0.tar.gz" -o wxwork_finance_sdk.tar.gz \
  && mkdir -p wxwork_finance_sdk \
  && tar -xf wxwork_finance_sdk.tar.gz -C wxwork_finance_sdk --strip-components=1 \
  && ( \
      cd wxwork_finance_sdk/php7-wxwork-finance-sdk \
      && phpize \
      && ./configure --with-wxwork-finance-sdk=/tmp/wxwork_finance_sdk/C_sdk \
      && make && make install \
  ) \
  && cp /tmp/wxwork_finance_sdk/C_sdk/libWeWorkFinanceSdk_C.so /usr/local/lib/libWeWorkFinanceSdk_C.so \
  && echo "extension=wxwork_finance_sdk.so" > /etc/php7/conf.d/50_wxwork_finance_sdk.ini \
  && php --ri wxwork_finance_sdk
```
