FROM ruby:2.4.0

RUN mkdir /pro
WORKDIR /pro

ADD Gemfile /pro/Gemfile
ADD Gemfile.lock /pro/Gemfile.lock
RUN bundle install

RUN apt-get update && apt-get install -y postgresql-client
