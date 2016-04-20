## Role

Communication between browser and application.

## Setup

[https://github.com/primus/primus](https://github.com/primus/primus)

```
cd servers/primus
npm install
```

## Procfile

```
dialogI: sh -c 'cd ./servers/primus && exec coffee entry.coffee'
dialogO: sh -c 'cd ./servers/primus && exec coffee outgo.coffee'
```
