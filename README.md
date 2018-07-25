## Pro - UDD polyglot anti-framework for modern web and standalone applications

[![Join the chat at https://gitter.im/madmaniak/pro](https://badges.gitter.im/madmaniak/pro.svg)](https://gitter.im/madmaniak/pro?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### Start

**Pro** consists of 2 parts: _template_ that provides basic file structure, for you to start working right away, and _framework_ which brings core libraries and tools installed in `framework/` dir.

#### Template
Create your project template with:

```sh
git clone git@github.com:madmaniak/pro <your_project> -o pro-template

# create an empty repo on github or somewhere else and:

git remote add origin git@github.com:<user>/<your_project>.git
git push -u origin master
```

#### Framework
Next, tell git to download `pro-framework`:

```sh
git submodule init
git submodule update
```

#### Setup and run

Pro uses [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/install) (version >= 1.9.0 recommended). Be sure you have it installed and working beforehand.

```sh
./pro s
```

Visit [http://localhost:3000](http://localhost:3000)
and
[http://localhost:8000](http://localhost:8000) for database management.

### Upgrade Pro to the newest version

```
git pull pro-template master
git submodule update
```

### Example app ###

[pro-example-app](https://github.com/madmaniak/pro-example-app).
