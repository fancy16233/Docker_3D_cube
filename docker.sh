#!/bin/bash

sudo docker stop app
sudo docker rm app
sudo docker rmi app

sudo docker build -t app .
sudo docker start afaf7b6bf309 
sudo docker run  -i -t -d --name=app -p 8080:80 app 
