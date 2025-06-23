FROM openjdk:17-jdk-slim

# Diretório onde a aplicação vai rodar
WORKDIR /app

# Copia o JAR do projeto para o container
COPY target/seu-app.jar app.jar

# Copia um script que vamos criar para lidar com o credentials.json
COPY start.sh .

# Dá permissão de execução ao script
RUN chmod +x start.sh

# Porta usada pela API
EXPOSE 8080

# Comando de entrada
ENTRYPOINT ["./start.sh"]
