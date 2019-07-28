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
1. Now you can run your database with the following stack configuration file:
   ```yaml
      version: '3.3'
      services:
        mydb_test_01:
          image: oracle/database:19.3.0-ee
          environment:
            - ORACLE_PWD=mypass
            - ORACLE_PDB=CUSTOMSCRIPTS
          volumes:
            - mydb_test_01:/opt/oracle/oradata
          ports:
            - 1521
            - 5500
          configs:
            - source: mydb_config
              target: /opt/oracle/scripts/setup/mydb_setup.sql
        mydb_test_02:
          image: oracle/database:19.3.0-ee
          environment:
            - ORACLE_PWD=mypass
            - ORACLE_PDB=CUSTOMSCRIPTS
          volumes:
            - mydb_test_02:/opt/oracle/oradata
          ports:
            - 1521
            - 5500
          configs:
            - source: mydb_config
              target: /opt/oracle/scripts/setup/mydb_setup.sql
      configs:
        mydb_config:
          file: /home/oracle/mydb_setup.sql
      volumes:
        mydb_test_01:
        mydb_test_02:
   ```
        
      
