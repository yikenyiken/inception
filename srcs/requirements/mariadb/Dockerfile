FROM		alpine:3.22.1
RUN		apk add --no-cache mariadb mariadb-client
RUN		mkdir -p /var/lib/mysql && chown -R mysql: /var/lib/mysql
RUN		mkdir -p /run/mysqld && chown -R mysql: /run/mysqld
COPY		conf/docker-entrypoint.sh /usr/local/bin/
EXPOSE		3306
ENTRYPOINT	["/usr/local/bin/docker-entrypoint.sh"]
CMD		["mysqld", "--user=mysql", "--datadir=/var/lib/mysql", "--skip-networking=0"]
