# Testing environment with Docker images for Oracle database
Our purpose is to use Docker images for Oracle database in our testing environment.

We want to test different configurations of our application and for that purpose we will need a base image of our database that will be instanciated on each test.

We propose two solutions for this problem:
* Set up a configuration script that would run every time the empty database image is started.
This would populate the database with the necessary data to run our application test.
* Instanciate the empty database and then connect our application to it.
We would then configure the database and when ready we would commit the changes to create a snapshot.
This snapshot would constitute the base image to be run on every test.

These are the first steps common to both solutions: 
1. Download the necessary configuration files to build the images:
   ```bash
      git clone -n --depth=1 https://github.com/oracle/docker-images.git
      cd docker-images && git checkout HEAD OracleDatabase/SingleInstance
   ```
1. Download the desired version of the database from this link:
   * https://www.oracle.com/technetwork/database/enterprise-edition/downloads/index.html
1. Copy the downloaded ZIP file to the following folder: 
   ```bash
      docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0
   ```
Once this is completed you need to proceed with the desired solution:
* [Initialization script](startup.md)
* [Snapshot base image](snapshot.md)
      
