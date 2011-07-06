# # Benchmarking your TCP server with Node.js
#***   
       
net= require('net')
net.createServer (conn) ->
  conn.on 'data', (data) ->       
    setTimeout -> 
      conn.end(data)
    , 500
    
.listen 4000