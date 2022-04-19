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
version: "3"
services: 
  sonarqube:
    image: sonarqube:lts
    depends_on:
      - db
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://db:5432/sonar
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonar
    networks:
      - sonar-network
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_extensions:/opt/sonarqube/extensions
      - sonarqube_logs:/opt/sonarqube/logs
    ports:
      - "9000:9000"
  db:
    image: postgres:12
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonar
    volumes:
      - postgresql:/var/lib/postgresql
      - postgresql_data:/var/lib/postgresql/data
volumes:
  sonarqube_data:
  sonarqube_extensions:
  sonarqube_logs:
  postgresql:
  postgresql_data:
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
export sonar_token="383769908cc1c26sdfgd76d57ce659e0aca361bc"
```
### we can run and test our code...
```bash
mvn spring-boot:run
```
## Run our build.
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
