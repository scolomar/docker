#!/bin/sh
sudo yum update -y

sudo amazon-linux-extras install docker -y
sudo systemctl enable docker
sudo systemctl start docker

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
EOF

setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable --now kubelet

ip=$( ip r | awk /^10.100.10.0/'{ print $9 }' )
echo $ip k8smaster | sudo tee --append /etc/hosts

