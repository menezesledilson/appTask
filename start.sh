#!/bin/bash

# Caminho onde vamos salvar o arquivo credentials.json
CREDENTIALS_PATH="/app/credentials.json"

# Escreve o conteúdo da variável de ambiente no arquivo
echo "$GOOGLE_CREDENTIALS" > "$CREDENTIALS_PATH"

# Roda a aplicação com o caminho do credentials.json
exec java -jar app.jar
