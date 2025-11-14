# Dockerfile (explicit file)
FROM eclipse-temurin:11-jdk
COPY target/hello-docker-1.0-SNAPSHOT.jar /app/hello-docker-1.0-SNAPSHOT.jar
WORKDIR /app
ENTRYPOINT ["java", "-jar", "hello-docker-1.0-SNAPSHOT.jar"]
