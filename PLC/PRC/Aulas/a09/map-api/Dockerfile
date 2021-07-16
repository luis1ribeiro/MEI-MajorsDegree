# Precisamos da imagem node
FROM node
WORKDIR /app
# Copiamos a nossa app para lá
COPY ..
# Instalar dependências
RUN npm i
EXPOSE 13000
CMD ["npm", "start"]