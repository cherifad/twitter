FROM node:14

RUN mkdir /app
WORKDIR /app

RUN npm install -g strapi

RUN strapi new my-strapi-app --dbclient=mongo --dbhost=localhost --dbport=27017 --dbname=strapi --dbusername=strapi --dbpassword=strapi --dbssl=false

WORKDIR /app/my-strapi-app

EXPOSE 1337

CMD ["npm", "start"]
