# # Basic http server  
#***   
# * [Node API doc - HTTP](http://nodejs.org/docs/v0.4.9/api/http.html#http.Server)
#***   
# ### HTTP
# To use the HTTP server and client one must require('http').    
#
# The HTTP interfaces in Node are designed to support many features of the protocol which have been traditionally difficult to use. In particular, large, possibly chunk-encoded, messages. The interface is careful to never buffer entire requests or responses--the user is able to stream data.
# 
# HTTP message headers are represented by an object like this:
# 
# { 'content-length': '123',
#   'content-type': 'text/plain',
#   'connection': 'keep-alive',
#   'accept': '*/*' }
http = require('http')
 
# ### response.writeHead(statusCode, [reasonPhrase], [headers])
# This method must only be called once on a message and it must be called before response.end() is called.
# If you call response.write() or response.end() before calling this, the implicit/mutable headers will be calculated and call this function for you.
server = http.createServer (req, res) ->
  console.log 'new req'
  res.writeHead 200,
    'Content-Type': 'text/pain'
  res.end 'Hello World'

# ### server.listen(port, [hostname], [callback]) 
# Begin accepting connections on the specified port and hostname. If the hostname is omitted, the server will accept connections directed to any IPv4 address (INADDR_ANY).
# 
# To listen to a unix socket, supply a filename instead of port and hostname.
# 
# This function is asynchronous. The last parameter callback will be called when the server has been bound to the port.
server.listen 4000, 'localhost'