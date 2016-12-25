base = require('./base')

primus = base.createPrimus(8090)
primus.on 'connection', (spark) ->

  spark.on 'data', (data) ->
    job = "front/#{data.event}"
    payload = JSON.stringify L.merge(data, sid: spark.id)

    Disque.addjob(job, payload, 60, 'replicate', 1, 'retry', 0, 'ttl', 1) (err, id) ->
      return console.error(err) if err
      console.log "(#{id} - #{job}): #{payload}"
