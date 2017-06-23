FROM seif/docker-mono-fastcgi-nginx
ADD Project /var/www/
CMD ["/usr/sbin/runit_bootstrap"]
