FROM node

RUN mkdir -p /primus
WORKDIR /primus

RUN npm install -g browserify coffee-script derequire http-server
ADD package.json package.json
RUN npm install && cd node_modules/primus && npm install && npm run build
