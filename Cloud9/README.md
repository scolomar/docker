How to install docker-compose in AWS Cloud9:

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```
https://aws.amazon.com/blogs/publicsector/how-to-develop-microservices-using-aws-cloud9-docker-and-docker-compose/


How to install kubectl in AWS Cloud9:
```bash
sudo curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl
sudo chmod +x /usr/local/bin/kubectl
sudo yum -y install jq gettext bash-completion
kubectl completion bash &gt;&gt;  ~/.bash_completion
source /etc/profile.d/bash_completion.sh
source ~/.bash_completion
kubectl completion bash >>  ~/.bash_completion
source /etc/profile.d/bash_completion.sh
source ~/.bash_completion
kubectl version
```
https://itzone.com.vn/en/article/create-and-set-up-the-necessary-environments-for-kubernetes-on-cloud-9-of-aws-using-eks/
