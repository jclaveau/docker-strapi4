FROM node:14-alpine as strapi4-deps
# Installing libvips-dev for sharp Compatability
RUN apk update && apk add bash
# RUN apk update && apk add  build-base gcc autoconf automake zlib-dev libpng-dev nasm  vips-dev
ARG NODE_ENV=development
# ARG NODE_ENV=production
# ENV NODE_ENV=${NODE_ENV}

# gyp offline https://github.com/nodejs/node-gyp/issues/1133
# ARG NODE_VER=v14.19.3
# RUN curl -sSL https://unofficial-builds.nodejs.org/download/release/v14.19.3/node-v14.19.3-headers.tar.gz \
#         -o /tmp/node-headers.tgz; \
# RUN curl -sSL https://nodejs.org/download/release/${NODE_VER}/node-${NODE_VER}-headers.tar.gz \
#         -o /tmp/node-headers.tgz; \
# COPY heroku/node-v14.19.3-headers.tar.gz /tmp/node-headers.tgz
# RUN npm config set tarball /tmp/node-headers.tgz

RUN npm add -g concurrently


WORKDIR /opt/
RUN npx create-strapi-app@latest strapi-tmp-project --quickstart --no-run
RUN yarn add pg pg-connection-string mysql

# TODO
# Remove -dev packages used for Sharp/libvips building
# Remove tmp project
# add pg && mysql

FROM strapi4-deps as strapi4-sharp-tests
RUN apk add git
WORKDIR /opt/sharp-dev
RUN git clone https://github.com/lovell/sharp.git .
RUN yarn
# RUN yarn test-unit

FROM strapi4-deps as strapi4-postgres-tests
RUN apk add git
WORKDIR /opt/postgres
RUN git clone https://github.com/brianc/node-postgres.git .
RUN yarn
# RUN yarn test-unit

