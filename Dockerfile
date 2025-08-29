# Estágio 1: Build da aplicação React
FROM node:18-alpine AS build
WORKDIR /app

# Copia package.json e package-lock.json para aproveitar o cache do Docker
COPY package*.json ./
RUN npm install

# Copia o resto do código da aplicação
COPY . .

# Comando para buildar a aplicação para produção
# NOTA: O seu projeto não tem um script de build, então este passo foi removido.
# Se você usar Vite ou Create React App, o comando seria: RUN npm run build
# Por agora, vamos servir os arquivos de desenvolvimento.

# Estágio 2: Servir a aplicação com Nginx
FROM nginx:alpine

# Copia os arquivos estáticos da aplicação para a pasta do Nginx
# Como não há passo de build, copiamos todo o conteúdo.
COPY --from=build /app /usr/share/nginx/html

# Remove o arquivo de configuração padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia o nosso arquivo de configuração customizado
COPY nginx.conf /etc/nginx/conf.d

# Expõe a porta 80
EXPOSE 80

# Inicia o Nginx
CMD ["nginx", "-g", "daemon off;"]