FROM nginx:latest

RUN apt-get update && apt-get install -y supervisor && rm -rf /var/lib/apt/lists/*

COPY update_index.sh /usr/local/bin/update_index.sh
RUN chmod +x /usr/local/bin/update_index.sh

COPY nginx.conf /etc/nginx/nginx.conf

VOLUME /usr/share/nginx/html

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

EXPOSE 80
