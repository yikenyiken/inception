FROM		alpine:3.22.1
RUN		apk add --no-cache php83-cli php83-phar php83-curl php83-mysqli php83-iconv	\
		php83-fpm
RUN		echo "listen = 0.0.0.0:9000" >> /etc/php83/php-fpm.d/www.conf
RUN		wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar	\
		&& chmod +x wp-cli.phar								\
		&& mv wp-cli.phar /usr/local/bin/wp
COPY		conf/docker-entrypoint.sh /usr/local/bin
COPY		tools/inception.html /tmp
EXPOSE		9000
ENTRYPOINT	["/usr/local/bin/docker-entrypoint.sh"]
CMD		["php-fpm83", "-F"]
