docker image build --tag helloweb https://github.com/secobau/openshift/raw/master/Dockerfile/helloweb
#docker image ls
#docker image history helloweb
docker container run --publish 80:8080 --detach helloweb
docker container logs helloweb --follow
#curl http://localhost/webapp/resources/persons && echo
