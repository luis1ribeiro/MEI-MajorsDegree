# Indicamos a imagem de base
FROM node:15
# Criamos a pasta de trabalho dentro da imagem
WORKDIR /app
# Copiamos a nossa app para lá
COPY get_request.js .
COPY package.json .
# Instalamos as depêndencias
RUN npm install
# Criamos o dataset
RUN npm start
# Instalamos o json-server
RUN npm i json-server -g
# Expomos a porta em que irá correr
EXPOSE 3002
# Indicamos como arrancar a aplicação
CMD json-server -H 0.0.0.0 -p 3002 entidades.json