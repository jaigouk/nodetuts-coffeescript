# # Socket Chat
#***   
# * [Node API doc - Streams](http://nodejs.org/docs/v0.4.9/api/streams.html)
# * [Node API doc - File System](http://nodejs.org/docs/v0.4.9/api/fs.html)
# * [Node API doc - Util](http://nodejs.org/docs/v0.4.9/api/util.html#util.pump)
# * [node.ws.js](https://github.com/ncr/node.ws.js) - Basic Web Sockets Server for node.js with similar interface to tcp.createServer(...)
#***   

http= require('http')
fs= require('fs')
util= require('util')
ws= require('./asset/ws.js')

clients = []

http.createServer (req, res) ->
  res.writeHead 200,
    'Content-Type': 'text/html'    
    # ### fs.createReadStream(path, [options])
    # 
    # Returns a new ReadStream object (See Readable Stream).
    # 
    # options is an object with the following defaults:  
    #
    #``` 
    # { flags: 'r',
    #   encoding: null,
    #   fd: null,
    #   mode: 0666,
    #   bufferSize: 64 * 1024
    # } 
    #```
    #
    # options can include start and end values to read a range of bytes from the file instead of the entire file. Both start and end are inclusive and start at 0.
    # 
    # An example to read the last 10 bytes of a file which is 100 bytes long:
    #
    #``` 
    # fs.createReadStream('sample.txt', {start: 90, end: 99});
    #```
    #
  rs = fs.createReadStream __dirname + '/asset/template.html'
  util.pump(rs, res)

.listen 4000  

ws.createServer (websocket) ->                   
  username = ''
  websocket.on 'connect', (resource) ->
    clients.push(websocket)
    websocket.write('Welcome to this chat server!')      
    websocket.write('Please input your username.')      
  websocket.on 'data', (data) ->
    unless username
      username = data.toString()
      websocket.write "Welcome, #{username}!"    
    feedback = "#{username} said: #{data.toString()}"
    client.write(feedback) for client in clients

  websocket.on 'close', () ->
    pos = clients.indexOf(websocket)
    client.splice pos, 1 if pos >= 0 

.listen 8080