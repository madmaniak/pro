FROM node

RUN mkdir -p /pro/node_modules
WORKDIR /pro

RUN npm install -g webpack@1.15.0 webpack-dev-server@1.16.3

ADD framework/tools/bundler/webpack/package.json package.json
RUN npm install
RUN rm package.json
