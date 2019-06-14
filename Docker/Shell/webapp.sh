wget https://github.com/arun-gupta/docker-for-java/raw/master/chapter2/webapp.war
docker container run --detach --name web --publish 80:8080 --volume $PWD/webapp.war:/opt/jboss/wildfly/standalone/deployments/webapp.war jboss/wildfly
docker container logs web --follow
#curl http://localhost/webapp/resources/persons && echo
