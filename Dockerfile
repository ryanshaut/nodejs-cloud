FROM node:16

WORKDIR /app
COPY . /app/
ARG NODE_ENV=production
RUN npm install

CMD npm run prod
