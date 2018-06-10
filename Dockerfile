FROM node:10.4 as builder

USER node
WORKDIR /home/node/

RUN git clone https://github.com/Tentoe/discord-soundboard-webapp.git && \
  cd discord-soundboard-webapp && \
  npm install && \
  npm run build

FROM node:10.4

RUN apt-get update && apt-get install ffmpeg -y

USER node
WORKDIR /home/node/

ENV NODE_ENV production

RUN git clone https://github.com/Tentoe/discord-soundboard-api.git && \
  cd discord-soundboard-api && \
  npm install

COPY --from=builder /home/node/discord-soundboard-webapp/dist ./discord-soundboard-api/public


EXPOSE 8080
WORKDIR /home/node/discord-soundboard-api/
# TODO find better way to install ffmpeg
RUN npm i ffmpeg-binaries
CMD ["npm", "start"]
