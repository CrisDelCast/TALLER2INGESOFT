# Etapa de build
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /build
COPY . .
RUN mvn clean package -DskipTests

# Etapa de runtime
FROM openjdk:11
WORKDIR /home/app
COPY --from=builder /build/cloud-config/target/*.jar cloud-config.jar
EXPOSE 9296
ENTRYPOINT ["java", "-jar", "cloud-config.jar"]
