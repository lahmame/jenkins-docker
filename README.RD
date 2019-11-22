
# Create volume
mkdir /app/udd/wafaci
chmod 777 /app/udd/wafaci

# Create Build Workspace
git clone http://gitlab..../wafaci

# Dockerimage (deps) + init config + credentials

# Copy Initial configuration
## Cette configuration initiale est maintenue manuelement et doit être synchronisée avec toutes les modifications effectuée directement sur Jenkins
mkdir /app/udd/wafaci/casc_configs
cp casc/*.yml /app/udd/wafaci/casc_configs/

mkdir /app/udd/wafaci/mvn
cp mvn/settings.xml /app/udd/wafaci/mvn/

# ... autre initial config

# Build images
docker build -t wafa/sonarqube:1.0 .

docker build -t wafa/wafa-ci:1.0  --build-arg "CRED_ROBOTOPS=$(cat credentials/robotops.txt)" --build-arg "CRED_SSH_87=$(cat credentials/ssh_87.txt)" .


# create infrastructure

# Create network
docker network create udd-net

docker run --name udd-db1 -d  --network udd-net -e POSTGRES_PASSWORD=wafa2012$$ -v /app/udd/wafaci/udd-db1:/var/lib/postgresql/data postgres

docker run --name sonarqube -d  --network udd-net -p 9001:9000 -e SONARQUBE_JDBC_USERNAME=sonarqube -e SONARQUBE_JDBC_PASSWORD=wafa2012$$ -e SONARQUBE_JDBC_URL=jdbc:postgresql://udd-db1/sonarqube -v /app/udd2/sonarqube-data:/opt/sonarqube/data wafa/sonarquebe:1.0

docker run --name wafaci -d --network udd-net  -p 18282:8080 -p 50002:50000 -v /app/udd2/wafaci:/var/jenkins_home wafa/wafa-ci:1.0


