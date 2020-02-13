#!/bin/sh
sudo yum update -y
sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker
sudo docker swarm init
f=/token_ucp
echo " export UCP_ADMIN_USERNAME=$( openssl rand -base64 32 | tr -d '+=/A-Z0-9' | fold -w 8  | head -1 )" 1> $f
echo " export UCP_ADMIN_PASSWORD=$( openssl rand -base64 32 | tr -d '+=/'       | fold -w 16 | head -1 )" 1>> $f
export UCP_ADMIN_USERNAME=$( awk -F= /UCP_ADMIN_USERNAME/'{ print $2 }' $f )
export UCP_ADMIN_PASSWORD=$( awk -F= /UCP_ADMIN_PASSWORD/'{ print $2 }' $f )
IP=$( ip route | grep eth0.*src | awk '{ print $9 }' )
sudo docker container run --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:2.2.22 install --host-address $IP --admin-username $UCP_ADMIN_USERNAME --admin-password $UCP_ADMIN_PASSWORD
