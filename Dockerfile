FROM node:16-alpine
WORKDIR /usr/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8081
CMD ["node","server.js"]

