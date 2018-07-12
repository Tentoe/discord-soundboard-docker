FROM node:8.11-stretch as builder

USER node
WORKDIR /home/node/

RUN git clone https://github.com/Tentoe/discord-soundboard-webapp.git && \
  cd discord-soundboard-webapp && \
  npm install && \
  npm run build

RUN git clone https://github.com/Tentoe/discord-soundboard-api.git && \
  cd discord-soundboard-api && \
  npm install && \
  npm run build


FROM node:8.11-stretch

RUN echo "deb http://www.deb-multimedia.org stretch main non-free \n\
deb-src http://www.deb-multimedia.org stretch main non-free" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install deb-multimedia-keyring -y --allow-unauthenticated --no-install-recommends && \
  apt-get update && \
  apt-get install ffmpeg -y --no-install-recommends

USER node
WORKDIR /home/node/

ENV NODE_ENV development

  
COPY --from=builder /home/node/discord-soundboard-api/built ./built
COPY --from=builder /home/node/discord-soundboard-api/package* ./
COPY --from=builder /home/node/discord-soundboard-webapp/dist ./built/static

RUN npm i --only=production

EXPOSE 8080

CMD ["npm", "start"]
