#!/bin/sh
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
# PUT BELOW THE OUTPUT OF LEADER DEPLOYMENT (WORKER TOKEN)
#sudo docker swarm join --token SWMTKN-1-50f90xrgjnodkhgayk1j87l9iykch5so1nem1yosywiytvd0z2-0881s24h7q6saahhxkaiu5scw 192.168.4.100:2377
