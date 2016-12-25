FROM ruby:2.3.3

RUN mkdir /pro
WORKDIR /pro

ADD Gemfile /pro/Gemfile
ADD Gemfile.lock /pro/Gemfile.lock
RUN bundle install

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -y lighttpd nodejs php5 php5-pgsql yarn && \
yarn global add browserify coffee-script derequire http-server webpack webpack-dev-server

RUN git clone https://github.com/antirez/disque.git && cd disque && make && \
cp src/disque-server /usr/local/bin && cp src/disque /usr/local/bin && \
cp src/disque-check-aof /usr/local/bin

ADD framework/tools/consumers/ruby/Gemfile /pro/framework/tools/consumers/ruby/Gemfile
RUN cd framework/tools/consumers/ruby && bundle install

RUN mkdir -p /tmp/node_modules/primus/tmp/node_modules/webpack
ADD framework/tools/communication/primus/package.json /tmp/node_modules/primus/package.json
ADD framework/tools/bundler/webpack/package.json /tmp/node_modules/webpack/package.json

RUN cd /tmp/node_modules/primus && yarn install
RUN cd /tmp/node_modules/primus/node_modules/primus && yarn install
RUN cd /tmp/node_modules/webpack && yarn install

RUN mkdir -p /pro/node_modules
RUN cp -r /tmp/node_modules/primus/node_modules/* /tmp/node_modules/webpack/node_modules/* /pro/node_modules

ADD . /pro
