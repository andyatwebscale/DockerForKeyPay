docker stop sql2019

docker rm sql2019

docker rmi database

cd C:\Projects\DockerForKeyPay\DockerSetupShard245

docker build -t database .

docker run --name "sql2019"  -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=SaPassword1" -p 1433:1433 -v ~/C/DbBackupFiles:/backups database