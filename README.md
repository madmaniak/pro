## Pro - UDD polyglot anti-framework for modern web and standalone applications

[![Join the chat at https://gitter.im/madmaniak/pro](https://badges.gitter.im/madmaniak/pro.svg)](https://gitter.im/madmaniak/pro?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### Start

```
git clone git@github.com:madmaniak/pro <your_project> -o pro

# create an empty repo on github or somewhere else and:

git remote add origin git@github.com:<user>/<your_project>.git
git push -u origin master
```

#### Manual environment setup

Checkout [tools](https://github.com/madmaniak/pro/tree/master/tools) subdirectories
and read there about dependencies. It takes about 30 minutes to install all of them.

#### Auto setup using Vagrant

Install [Vagrant](https://www.vagrantup.com/downloads.html) (v1.8.1 or greater). If you've tried to install stuff manually make sure there is no ```node_modules``` directory in ```tools/webpack``` and ```tools/primus```.

```
vagrant up
vagrant ssh
cd /vagrant
```

#### After setup
```
foreman start
```

Visit [http://localhost:3000](http://localhost:3000). Blank page means good.

### Upgrade Pro to the newest version

```
git pull pro master
git push
```

### Example app ###

[pro-example-app](https://github.com/madmaniak/pro-example-app).
