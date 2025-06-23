# Etapa 1: Compilar o projeto
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copia tudo para dentro do container
COPY . .

# Rodar o build usando o pom.xml na pasta backend/demo
RUN mvn -f backend/demo/pom.xml clean package -DskipTests

# Etapa 2: Rodar a aplicação
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copia o .jar gerado da etapa anterior
COPY --from=build /app/backend/demo/target/demo-0.0.1-SNAPSHOT.jar app.jar

# Copia o start.sh
COPY start.sh .

RUN chmod +x start.sh

EXPOSE 8080

ENTRYPOINT ["./start.sh"]
