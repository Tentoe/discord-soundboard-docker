FROM node:10.4 as builder

USER node
WORKDIR /home/node/

RUN git clone https://github.com/Tentoe/discord-soundboard-webapp.git && \
  cd discord-soundboard-webapp && \
  npm install && \
  npm run build

FROM node:10.4

USER node
WORKDIR /home/node/

ENV NODE_ENV development

RUN git clone https://github.com/Tentoe/discord-soundboard-api.git


WORKDIR /home/node/discord-soundboard-api/

RUN npm install && npm run build
  

COPY --from=builder /home/node/discord-soundboard-webapp/dist ./built/static


EXPOSE 8080

# TODO find better way to install ffmpeg
RUN npm i ffmpeg-binaries
CMD ["npm", "start"]
