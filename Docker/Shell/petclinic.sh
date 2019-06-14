docker image build --tag petclinic https://raw.githubusercontent.com/secobau/openshift/master/Docker/Dockerfile/petclinic
#docker image ls
#docker image history petclinic
docker container run --publish 80:8080 --detach --name petclinic petclinic
docker container logs petclinic --follow
#curl http://localhost&& echo
