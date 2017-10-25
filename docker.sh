#!/bin/bash

docker stop $(docker ps -a -q) // 停止所有容器
docker rm $(docker ps -a -q) //刪除所有容器


sudo docker build -t app . //以當前目錄下的DockerFile建立一個名稱叫做APP的映像
sudo docker run -d --name=app -p 8080:80 app //以APP映像建立一個名稱為APP的容器 並 開啟容器埠號8080對應到主機埠號80 以及-d參數 讓該容器在背景執行。

sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=mypass' -v /home/fancy16233/Desktop/SQLfile:/var/opt/mssql -p  1433:1433 -d microsoft/mssql-server-linux
 //上行為啟動一個Ms SQL的容器 -e參數 ACCEPT_EULA=Y為設定同意使用者條款 SA_PASSWORD=mypass為設定SA 密碼 -v參數建立一個Volume 讓/home/fancy16233/Desktop/SQLfile 主機目錄 
 與/var/opt/mssql容器目錄對應在一起 最後-d參數背景執行 -p設定主機:容器 對應埠號。
 
