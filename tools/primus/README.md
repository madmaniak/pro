## Role

Communication between browser and application.

## Setup

[https://github.com/primus/primus](https://github.com/primus/primus)

```
cd tools/primus
npm install
```

## Procfile

```
dialogI: sh -c 'cd ./tools/primus && exec coffee entry.coffee'
dialogO: sh -c 'cd ./tools/primus && exec coffee outgo.coffee'
```
