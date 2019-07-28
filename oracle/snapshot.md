# Using a snapshot of the database after initialization
In order to create a snapshot of our database once initialized we need the image not to use volumes 
to store the data otherwise the snapshot would not include that data.

The Oracle images created by default use volumes to improve the performance of the database so that we need to modify the Dockerfile
to create a new image that will not use volumes.
1. Modify the Dockerfile with the following command: 
   ```bash
      sed -i /VOLUME/d /home/oracle/docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0/Dockerfile
   ```
1. Now build the image from that Dockerfile:
   ```bash
      cd docker-images/OracleDatabase/SingleInstance/dockerfiles && sudo ./buildDockerImage.sh -v 19.3.0 -e
   ```
1. Now you can run your database with the following command:
   ```bash
      docker container run --name mydb_builder -p 1521 -p 5500 oracle/database:19.3.0-ee
   ```
1. Once your database is initialized and running you can connect to the database from your application and complete the installation.
1. After completing the installation we want to stop our container and create the new image:
   ```bash
      docker container stop -t 60 mydb_builder
      docker container commit -m "Image with prebuilt database" mydb_builder oracle/database-snapshot:19.3.0-ee
      docker container rm mydb_builder
      docker image rm oracle/database:19.3.0-ee
   ```
1. You can restore the Dockerfile to its original state: 
   ```bash
      cd /home/oracle/docker-images && git checkout -- OracleDatabase/SingleInstance/dockerfiles/19.3.0/Dockerfile
   ```
1. The image is now ready to be used in your testing environment:
   ```bash
      docker container run --name mydb_01 -v mydb_01_volume:/opt/oracle/oradata -p 1521 -p 5500 oracle/database-snapshot:19.3.0-ee
   ```
        
            
