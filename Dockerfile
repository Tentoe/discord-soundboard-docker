FROM node:10.4-stretch as builder

USER node
WORKDIR /home/node/

RUN git clone https://github.com/Tentoe/discord-soundboard-webapp.git && \
  cd discord-soundboard-webapp && \
  npm install && \
  npm run build

FROM node:10.4-stretch

RUN echo "deb http://www.deb-multimedia.org stretch main non-free \n\
deb-src http://www.deb-multimedia.org stretch main non-free" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install deb-multimedia-keyring -y --allow-unauthenticated --no-install-recommends && \
  apt-get update && \
  apt-get install ffmpeg -y --no-install-recommends

USER node
WORKDIR /home/node/

ENV NODE_ENV development

RUN git clone https://github.com/Tentoe/discord-soundboard-api.git


WORKDIR /home/node/discord-soundboard-api/

RUN npm install && npm run build
  

COPY --from=builder /home/node/discord-soundboard-webapp/dist ./built/static


EXPOSE 8080

CMD ["npm", "start"]
