## Pro - UDD polyglot anti-framework for the web or whatever

[![Join the chat at https://gitter.im/madmaniak/pro](https://badges.gitter.im/madmaniak/pro.svg)](https://gitter.im/madmaniak/pro?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### Start

```
git clone git@github.com:madmaniak/pro <your_project> -o pro

# create an empty repo on github or somewhere else and:

git remote add origin git@github.com:<user>/<your_project>.git
git push -u origin master

```

Checkout the servers directory and add/remove if needed in the Procfile.
Read there also about needed dependencies. Then just:

```
foreman start
```

### Upgrade Pro to the newest version

```
git pull pro master
git push
```
