# Initializing the database through a setup script after startup

1. Build the image:
   ```bash
      cd docker-images/OracleDatabase/SingleInstance/dockerfiles && sudo ./buildDockerImage.sh -v 19.3.0 -e
   ```
1. You can define your custom startup and setup scripts so as to iniatilize the database and create the necessary tables and users for your application. 
   For example we are going to use the scripts located in the following folder:
   ```bash
      docker-images/OracleDatabase/SingleInstance/samples/customscripts/
   ```
1. Now we can run the container to set up the test environment:
   ```bash
      docker container run --name mydb_01 -v mydb_01_volume:/opt/oracle/oradata -v ~/docker-images/OracleDatabase/SingleInstance/samples/customscripts:/opt/oracle/scripts/setup/:ro -e ORACLE_SID=ORCLSCRIPT -e ORACLE_PDB=CUSTOMSCRIPTS -p 1521 -p 5500 oracle/database-snapshot:19.3.0-ee
   ```
   
