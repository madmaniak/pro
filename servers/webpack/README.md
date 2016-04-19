## Role

Bundling static files and serving them for development - HTML, JS, CSS,
images.

## Setup

[http://webpack.github.io/docs](http://webpack.github.io/docs)

```
cd servers/webpack
npm install
```

## Procfile

```
static-files: sh -c 'cd ./servers/webpack && exec npm start'
```
