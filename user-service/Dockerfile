# Usa una imagen base de Java 11, que es la que usa tu proyecto.
FROM openjdk:11-jre-slim

# Establece el directorio de trabajo dentro del contenedor.
WORKDIR /app

# Copia el archivo .jar que fue construido por Maven en el pipeline de GitHub Actions.
# Lo copiamos desde la carpeta 'target' del microservicio al directorio raíz de la imagen.
COPY target/*.jar app.jar

# Expone el puerto en el que la aplicación se ejecuta.
EXPOSE 8700

# El comando que se ejecuta cuando el contenedor arranca.
ENTRYPOINT ["java", "-jar", "app.jar"]
