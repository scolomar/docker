docker image build --tag helloworld https://raw.githubusercontent.com/secobau/openshift/master/Docker/Dockerfile/helloworld
#docker image ls
#docker image history helloworld
docker container run helloworld
docker container run helloworld HOLA MUNDO
