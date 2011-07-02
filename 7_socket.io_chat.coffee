# # Socket.io Chat Server
#***   
# * [Socket.io](http://socket.io/) - **Socket.IO** aims to make realtime apps possible in every browser and mobile device, blurring the differences between the different transport mechanisms. It's care-free realtime 100% in JavaScript.
# * [Socket.io changelog](http://socket.io/#announcement)
# * [Socket.io Examples](https://github.com/LearnBoost/socket.io/tree/master/examples)
# * [nodecamp.eu 2011 (slides)](http://www.slideshare.net/3rdEden/socketio-8284496)
# * [nodeconf 2011 (slides)](http://cl.ly/0B0C3f133K1m3j422n0K)
# * [camp.nodejs 2010 (video)](http://camp.nodejs.org/videos/session-06_socketio_workshop-guillermo_rauch.html)
#***   
http= require('http')
fs= require('fs')
util= require('util')

server = http.createServer (req, res) ->
  res.writeHead 200,
    'Content-Type': 'text/html'    
  rs = fs.createReadStream __dirname + '/asset/template2.html'
  util.pump(rs, res)
server.listen 4000   

# ### Socket.io
                   
io= require('socket.io').listen(server)
io.sockets.on 'connection', (socket) ->
  username = ''  

  # ### Namespce
  #
  #```
  # socket.on('item')
  #```  
  #  
  # Socket.IO now gives you one `Socket` per namespace you define.
  # Each "sub-socket" or "namespace" has the same characteristics of any other Socket, but socket.io does the heavylifting of splitting the messages in a very lightweight and performant way. This technique is specially necessary for non-WebSocket transports, as they're usually associated with more than one connection.  
  #
  # Custom events allow you to simplify your code, and their implementation adds no overhead to the protocol. This means that if you don't use them, not much will change.

  #If you pass parameters, those will be automatically encoded and decoded in JSON for you. In addition, you can pass data around: 

  socket.on 'message', (msg) ->      
    if !username     
      username = msg                                             
      socket.emit 'message', "Welcome #{username}!\n"
    else
      io.sockets.emit 'message', "#{username} sent> #{msg}"   

