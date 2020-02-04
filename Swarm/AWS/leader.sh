#!/bin/sh
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker swarm init
sudo docker swarm join-token manager | grep token 1> token_manager
sudo docker swarm join-token worker  | grep token 1> token_worker
