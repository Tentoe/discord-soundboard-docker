FROM node:9.10 as builder

USER node
WORKDIR /home/node/

RUN git clone https://github.com/Tentoe/discord-soundboard-api.git && \
  cd discord-soundboard-api && \
  npm install && \
  npm run build

RUN git clone https://github.com/Tentoe/discord-soundboard-webapp.git && \
  cd discord-soundboard-webapp && \
  npm install && \
  npm run build

FROM node:9.10

USER node
WORKDIR /home/node/

ENV NODE_ENV production

COPY --from=builder /home/node/discord-soundboard-api/package.json .
COPY --from=builder /home/node/discord-soundboard-api/build ./build
COPY --from=builder /home/node/discord-soundboard-webapp/dist ./build/webapp

RUN npm install

EXPOSE 8080

CMD ["npm", "run", "startprod"]
