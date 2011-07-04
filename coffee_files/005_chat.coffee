# # Chat Server 
#***   
# * [Node API doc - Net](http://nodejs.org/docs/v0.4.9/api/net.html)
# * [Carrier](https://github.com/pgte/carrier) - Evented stream line reader for node.js 
#***   
net= require('net')
carrier= require('carrier')

connections = []
 
# ### net
# 
# The net module provides you with an asynchronous network wrapper. It contains methods for creating both servers and clients (called streams). You can include this module with require("net");
# 
# ### net.createServer([options], [connectionListener])
# 
# Creates a new TCP server. The connectionListener argument is automatically set as a listener for the 'connection' event.
net.createServer (conn) ->
  connections.push conn         
  
  conn.on 'close', () -> 
    pos = connections.indexOf conn
    connections.splice pos, 1 if pos >= 0
  
  conn.write 'Hello, welcome to this chat server!\n'
  conn.write 'Please input your user name: \n'
  username = ''
  carrier.carry conn, (line) ->
    if !username
      username = line
      conn.write "Hello #{username}! \n"
    conn.end() if line == 'quit' 
    for one_connection in connections
      one_connection.write("#{username}: #{line}\n")
    
.listen 4000