# Vai buscar a imagem do python
FROM python 
# Run para instalar biblioteca requests
RUN pip install requests
# Criamos a pasta de trabalho dentro da imagem
WORKDIR /app
# Copiamos o resto
COPY clav.py .
# Vamos buscar a informação e gravamos num ficheiro
RUN ["python","clav.py"]
# Expomos a porta
EXPOSE 8000
# Expomos a pasta e os seus conteúdos. Recursivamente exposta.
CMD python -m http.server