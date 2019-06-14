docker image build --tag java-getting-started https://raw.githubusercontent.com/secobau/openshift/master/Docker/Dockerfile/java-getting-started
#docker image ls
#docker image history java-getting-started
docker container run --publish 80:5000 --rm --detach --name java-getting-started java-getting-started
docker container logs java-getting-started --follow
