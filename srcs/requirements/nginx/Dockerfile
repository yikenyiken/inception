FROM	alpine:3.22.1
RUN	apk --no-cache add nginx openssl
RUN	mkdir /etc/nginx/ssl
RUN	openssl req -x509 -nodes -days 365 -subj "/CN=localhost" -newkey rsa:2048	\
	-keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt
COPY	tools/nginx.conf /etc/nginx/http.d/
EXPOSE	443
CMD ["nginx", "-g", "daemon off;"]
