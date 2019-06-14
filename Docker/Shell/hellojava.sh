docker image build --tag hellojava https://raw.githubusercontent.com/secobau/openshift/master/Docker/Dockerfile/hellojava
#docker image ls
#docker image history hellojava
docker container run hellojava
docker container run hellojava -help
