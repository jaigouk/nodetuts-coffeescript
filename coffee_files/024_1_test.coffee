net = require 'net'
stats = require './024_2_statistics'

connect = ->        
  process.stdout.write('#') 
  time = Date.now()
  conn = net.createConnection 4000

  conn.on 'connect', ->
    stats.collect 'connect', Date.now() - time
    console.log 'connected'     
    latencyTime = Date.now()
    conn.write 'Hello'                        
    conn.on 'data', ->
      stats.collect 'latency', Date.now() - latencyTime      
  
  conn.on 'close', ->
    console.log 'closed'
    conn.end

setInterval connect ,100

process.on 'SIGINT', -> 
  console.log "\n####### summary: "
  stats.summarize()
  process.exit()