FROM node

RUN mkdir -p /pro/node_modules
WORKDIR /pro

RUN npm install -g webpack@3.5.5

ADD framework/tools/bundler/webpack/package.json package.json
RUN npm install
RUN rm package.json
