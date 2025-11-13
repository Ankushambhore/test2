FROM eclipse-temurin:11-jdk
COPY target/*.jar /app/myapp.jar
WORKDIR /app
ENTRYPOINT ["java", "-jar", "myapp.jar"]
