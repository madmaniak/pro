#!/bin/bash
if [ -s 'docker-compose.yml' ]; then
  echo 'docker-compose.yml exists'
else
  echo 'Building docker-compose.yml'
  docker build -t pro:init -f framework/tools/containers/docker/Dockerfile . && \
  docker run -v $(pwd):/pro pro:init
fi

if [ $1 == 'server' -o $1 == 's' ]; then
  docker-compose up
elif [ $1 == 'build' ]; then
  docker-compose down && docker-compose build
elif [ $1 == 'console' -o $1 == 'c' ]; then
  docker exec -it `docker-compose ps -q consumer` bash -c "ruby framework/tools/starter/start.rb c"

  if [ $? -ne 0 ]; then
    echo 'Is the server running?'
  fi
fi
