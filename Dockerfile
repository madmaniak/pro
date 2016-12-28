FROM ruby:2.3.3

RUN mkdir /pro
WORKDIR /pro

ADD Gemfile /pro/Gemfile
ADD Gemfile.lock /pro/Gemfile.lock
RUN bundle install

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -y nodejs postgresql-client yarn && \
yarn global add browserify coffee-script derequire http-server

ADD framework/tools/communication/primus/package.json /tmp/node_modules/primus/package.json

RUN cd /tmp/node_modules/primus && yarn install
RUN cd /tmp/node_modules/primus/node_modules/primus && yarn install

RUN mkdir -p /pro/node_modules && \
cp -r /tmp/node_modules/primus/node_modules/* /pro/node_modules

ADD . /pro
