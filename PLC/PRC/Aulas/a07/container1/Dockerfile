# Indicamos a imagem de base
FROM node:15
# Criamos a pasta de trabalho dentro da imagem
WORKDIR /app
# Copiamos a nossa app para lá
COPY server1.js .
# Indicamos a porta onde irá correr -> Tem que bater certo com a que indicamos na script
EXPOSE 7777
# Indicamos como arrancar a aplicação -> Só existe um CMD para cada DockerFile
CMD ["node", "server1.js"]