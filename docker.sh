#!/bin/bash

sudo docker stop app
sudo docker rm app
sudo docker rmi app

sudo docker build -t app .
sudo docker start afaf7b6bf309 
sudo docker run  -i -t -d --name=app -p 8080:80 app

sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=mypass' -v /home/fancy16233/Desktop/SQLfile:/var/opt/mssql -p  1433:1433 -d microsoft/mssql-server-linux
 