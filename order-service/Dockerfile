FROM eclipse-temurin:11-jre
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8300
ENTRYPOINT ["java", "-jar", "app.jar"]
