FROM ruby:2.4.0

RUN mkdir /pro
WORKDIR /pro

ADD framework/tools/consumers/ruby/Gemfile /pro/Gemfile
ADD framework/tools/consumers/ruby/Gemfile.lock /pro/Gemfile.lock
RUN bundle install

RUN apt-get update && apt-get install -y postgresql-client
