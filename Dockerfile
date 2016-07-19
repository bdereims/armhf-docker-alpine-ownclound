FROM armhf/alpine
MAINTAINER Brice Dereims "bdereims@gmail.com"
EXPOSE 443

RUN apk update && apk upgrade

RUN apk add nginx openssl curl php5-fpm php5-json php5-mysql php5-curl php5-xml php5-iconv \
	php5-ctype php5-dom php5-gd php5-ftp php5-posix php5-zip php5-zlib php5-bz2 php5-openssl \
	php5-mcrypt php5-pdo_mysql php5-pdo_sqlite php5-sqlite3 php5-xmlreader \
	&& mkdir /run/nginx && mkdir /etc/nginx/ssl \
	&& rm -rf /var/cache/apk/*

RUN openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=FR/ST=Paris/L=Paris/O=RPI/OU=RPI/CN=blue-tale.mooo.com"

# install owncloud
ENV OWNCLOUD_VERSION 9.0.3 
ENV OWNCLOUD_PACKAGE owncloud-$OWNCLOUD_VERSION.tar.bz2
ENV OWNCLOUD_URL https://download.owncloud.org/community/$OWNCLOUD_PACKAGE
RUN mkdir -p /opt \
	&& cd /opt \
	&& curl -LOs $OWNCLOUD_URL \
	&& tar xjf $OWNCLOUD_PACKAGE \
	&& rm $OWNCLOUD_PACKAGE \
	&& mkdir -p /opt/owncloud/config /opt/owncloud/data \
	&& chown -R nginx:nginx /opt/owncloud \
	&& chmod 0770 /opt/owncloud/data

COPY nginx.conf /etc/nginx/nginx.conf
COPY php-fpm.conf /etc/php5/php-fpm.conf 
COPY startup.sh /root/.

CMD ["/root/startup.sh"]
