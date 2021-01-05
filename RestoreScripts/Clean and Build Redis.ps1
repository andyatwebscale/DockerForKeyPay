docker stop redis-container

docker rm redis-container

docker rmi redis

docker run -d --name redis-container -p 6379:6379 redis