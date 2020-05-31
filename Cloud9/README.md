# How to install docker-compose in AWS Cloud9:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version


```
https://aws.amazon.com/blogs/publicsector/how-to-develop-microservices-using-aws-cloud9-docker-and-docker-compose/


# How to install kubectl in AWS Cloud9:






```bash
sudo apt-get update
sudo apt-get install apt-transport-https gnupg2 -y


```
```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install kubectl -y


```
```bash
kubectl version --client
kubectl completion bash >> ~/.bash_completion
source /etc/profile.d/bash_completion.sh
source ~/.bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl


```
https://kubernetes.io/docs/tasks/tools/install-kubectl/

# How to install minikube in AWS Cloud9
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb


```
https://minikube.sigs.k8s.io/docs/start/

Now you need to resize the volume (2x):
```bash
sudo growpart /dev/nvme0n1 1 && sudo resize2fs /dev/nvme0n1p1


```
Now you can continue the installation:
```bash
minikube start
kubectl get node
minikube ip


```
https://minikube.sigs.k8s.io/docs/start/
