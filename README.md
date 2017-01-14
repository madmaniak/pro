## Pro - UDD polyglot anti-framework for modern web and standalone applications

[![Join the chat at https://gitter.im/madmaniak/pro](https://badges.gitter.im/madmaniak/pro.svg)](https://gitter.im/madmaniak/pro?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### Start

```sh
git clone git@github.com:madmaniak/pro <your_project> -o pro

# create an empty repo on github or somewhere else and:

git remote add origin git@github.com:<user>/<your_project>.git
git push -u origin master
```

#### Setup and run

[Docker Compose](https://docs.docker.com/compose/install) (version >= 1.9.0 recommended) is required.

```sh
# Build Docker configuration
docker build -t pro:init -f framework/tools/containers/docker/Dockerfile . && docker run -v $(pwd):/pro pro:init

docker-compose up --build

# it will download images and try to run pro but you will be notified
# about missing configs - copy them from the examples

docker-compose up
```

Visit [http://localhost:3000](http://localhost:3000)
and
[http://localhost:8000](http://localhost:8000) for database view.

### Upgrade Pro to the newest version

```
git pull pro master
git push
```

### Example app ###

[pro-example-app](https://github.com/madmaniak/pro-example-app).
