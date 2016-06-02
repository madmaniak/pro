base = require('./base')

connections = {}

primus = base.createPrimus(8088)
primus.on 'connection', (spark) ->

  spark.on 'data', (data) ->
    unless connections[data]
      connections[data] = spark.id
      spark.pair = data

  spark.on 'end', ->
    delete connections[spark.pair]

get_jobs = ->
  Disque.getjob('timeout', 0, 'count', 16, 'from', 'send') (err, jobs) ->
    setTimeout get_jobs, 0
    if err
    then console.error(err)
    else
      L.each jobs, (payload) ->
        data = payload[2]

        console.log data

        sid = /"sid":"([^"]*)"/.exec(data)[1]
        if sid == 'all'
          primus.write data
        else
          spark_id = connections[sid]
          primus.spark(spark_id)?.write data

get_jobs()
