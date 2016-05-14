## Role

Bundling static files and serving them for development - HTML, JS, CSS,
images.

## Setup

```
npm install webpack -g
```

```
cd servers/webpack
npm install
```

## Procfile

```
static-files: sh -c 'cd ./servers/webpack && exec npm start'
```
## Documentation

[http://webpack.github.io/docs/tutorials/getting-started](http://webpack.github.io/docs/tutorials/getting-started/)
