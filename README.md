
# Docker_3D_cube
**************
## Make Sure install docker on *Linux* and has more then 4GB RAM.
***********
## edit docker.sh
***********
``sudo docker stop app
sudo docker rm app
sudo docker rmi app

sudo docker build -t app .
sudo docker start afaf7b6bf309 
sudo docker run  -i -t -d --name=app -p 8080:80 app

sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=mypass' -v /home/fancy16233/Desktop/SQLfile:/var/opt/mssql -p  1433:1433 -d microsoft/mssql-server-linux``
 
change the /home/fancy16233/Desktop/Sqlfile to the directory where you put the *Knight_Tour_3D.bak* file.

Change *mypass* to the password you want.(At least 8 characters including uppercase, lowercase letters, base-10 digits and/or non-alphanumeric symbols)
*************
## edit /Project/Default.aspx.cs
*************
At line 26, edit 
`` string connectStr = "Data Source=tcp:163.18.21.223;Persist Security Info=True;Password=GhOst1945;User ID=sa;Initial Catalog=Knight_Tour_3D";``

change ip to your linux ip address and password you choose.
************
## open you SSMS(Sql Server Management Studio

recover the database(Knight_Tour_3D) Using the Knight_Tour_3D_bak file at /var/opt/mssql

## start the shell script
using the command  `sh docker.sh` to start the shell script and the script will automatically start all the containers.

## Get to it

open browser and type *yourIpAddress:8080*

and you will see the programe working.
