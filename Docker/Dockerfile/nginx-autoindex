FROM nginx
RUN sed -i '/index.htm/s/$/\nautoindex on;/' /etc/nginx/conf.d/default.conf&&rm -f /usr/share/nginx/html/*.html
