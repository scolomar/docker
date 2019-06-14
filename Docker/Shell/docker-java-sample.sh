docker image build --tag docker-java-sample https://raw.githubusercontent.com/secobau/openshift/master/Docker/Dockerfile/docker-java-sample
#docker image ls
#docker image history docker-java-sample
docker container run --rm --name docker-java-sample docker-java-sample
