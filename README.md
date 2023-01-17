# kojitechs Registration application

## It's always a good practice to build and test your code. hence we can leverage the following Devops tool set 

```bash
Maven 'main build tool.'
Jenkins 'as intergration tool'
Sonarqube 'for security hostspot testing'
We can spin up a sonarqube container 
```
you can use this file docker-compose.yml
```bash
vversion: '3'
services:
  db:
    image: mysql
    volumes:
      - mysql-data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: P1b7JBvP8II4
      MYSQL_DATABASE: webappdb
      MYSQL_USER: kojibello
      MYSQL_PASSWORD: P1b7JBvP8II4

  sonarqube:
    depends_on:
      - db
    image: kojibello/kojitechs-registration-app:1.2.01-pre-release
    restart: always
    ports:
      - "8080:8080"
    environment:
      DB_HOSTNAME: db
      DB_PORT: 3306
      DB_NAME: webappdb
      DB_USERNAME: kojibello
      DB_PASSWORD: P1b7JBvP8II4
volumes:
  mysql-data:
```
### 
login
https://localhost:9000
```bash
username: admin
password: admin
```
### reset password

### connect to postgres container get the prrocess id
### 
```bash
docker ps 
docker exec -it postgresId bash  
psql -U postgres 
psql -U sonar
```
## create a sonarqube token that would be used to lrun our build.
### next
export the token as an environment variable.
```bash
export sonar_token="585d27c738bdc53dbf515ff15b0990727c8b7e31"
```
### we can run and test our code...
```bash
mvn spring-boot:run
```
## mvn build and call sonarqube for bug test.
```bash
mvn sonar:sonar -Dsonar.login=$sonar_token
```
### monitor the build process on sonar
## Now Let's Build our app.
The pom.xml already contains docker depencies hence it's going to creat .war file and would be stored in ./target folder.
## Hence
make sure you docker instance is running.
```bash
mvn package
docker ps
notice an image name "kojitechs/kojitechs-registration-app"
```

### Now let's push our war file to an artifactor.(github)
and also push our image container to ecr.
to push image to ecr let's tag our image 
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin {account_id}.dkr.ecr.us-east-1.amazonaws.com

docker tag kojitechs/kojitechs-registration-app:1.0.0-register-app {account_id}.dkr.ecr.us-east-1.amazonaws.com/kojitechs-registration-app:v1.0.0

docker push {account_id}.dkr.ecr.us-east-1.amazonaws.com/kojitechs-registration-app:v1.0.0

docker image rm {account_id}.dkr.ecr.us-east-1.amazonaws.com/kojitechs-registration-app:v1.0.0 
```
The end!

## Create user in DB
```
INSERT INTO user (userid, email_address, first_name, last_name, password, ssn, user_name)
VALUES ("101", "kojitechs@gmail.com", "koji", "bello", "$2a$10$w.2Z0pQl9K5GOMVT.y2Jz.UW4Au7819nbzNh8nZIYhbnjCi6MG8Qu", "202XXX", "kojitechs");
INSERT INTO role (roleid, role) VALUES ("201", "ADMIN");
INSERT INTO user_role (userid, roleid) VALUES ("101", "201");
```