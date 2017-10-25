FROM seif/docker-mono-fastcgi-nginx //指定使用的基底映象
ADD Project /var/www/ //將Project主機目錄加入到 /var/www 容器目錄中
CMD ["/usr/sbin/runit_bootstrap"] //指定該Dockerfile製作的映像啟動成容器時要執行的指令。這邊是要啟動NGINX SERVER
