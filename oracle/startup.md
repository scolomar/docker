# Initializing the database through a setup script after startup
1. Create a user named oracle, access the system with that user account and proceed with the following commands:
   ```bash
      git clone -n --depth=1 https://github.com/oracle/docker-images.git
      cd docker-images && git checkout HEAD OracleDatabase/SingleInstance && git checkout -b oracle
   ```
   
2. Download the desired version of the database from this link:
   * https://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
   
3. Copy the downloaded ZIP file to the following folder: 
   ```bash
      docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0
   ```
 
4. Now build the image with the following command:
   ```bash
      cd docker-images/OracleDatabase/SingleInstance/dockerfiles && sudo ./buildDockerImage.sh -v 19.3.0 -e
   ```
   
5. You can define your custom startup and setup scripts so as to iniatilize the database and create the necessary tables and users for your application. 
   For example create a file:
   ```bash
      /home/oracle/mydb_setup.sql 
   ```
   with the following content:
   ```sql
      ALTER SESSION SET CONTAINER=CUSTOMSCRIPTS;
      CREATE USER TEST IDENTIFIED BY test;
      GRANT CONNECT, RESOURCE TO TEST;
      ALTER USER TEST QUOTA UNLIMITED ON USERS;
      CONNECT TEST/test@//localhost:1521/CUSTOMSCRIPTS;
      CREATE TABLE PEOPLE(name VARCHAR2(10));
      INSERT INTO PEOPLE (name) VALUES ('Larry');
      INSERT INTO PEOPLE (name) VALUES ('Bruno');
      INSERT INTO PEOPLE (name) VALUES ('Gerald');
      COMMIT;
      exit;
   ```

6. Now you can run your database with the following stack configuration file:
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
        
      
