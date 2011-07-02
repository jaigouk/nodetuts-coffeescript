http= require('http')
fs= require('fs')
sys= require('sys')

server = http.createServer (req, res) ->
  res.writeHead 200,
    'Content-Type': 'text/html'    
  rs = fs.createReadStream __dirname + '/asset/template2.html'
  sys.pump(rs, res)
server.listen 4000   
                   
io= require('socket.io').listen(server)


io.sockets.on 'connection', (socket) ->

  # socket.send 'Welcome to this socket.io chat server!\n'
  # socket.send 'Please input your username.\n'
  
  username = ''  
  
  socket.on 'message', (msg) ->    
  
    if !username     

      username = msg                                             
      socket.emit 'message', "Welcome #{username}!\n"
    else
      io.sockets.emit 'message', "#{username} sent> #{msg}"

    
  # socket.on 'set nickname', (name) ->
  #   socket.set 'nickname', name, () ->
  #     socket.emit 'ready' 
      
  
  
  # socket.on 'message', (message) ->
  #   socket.get 'nickname', (name) ->
  #     socket.emit "Welcome, #{name}!" 
    # if !username
    #   username = message
    #   socket.emit "Welcome, #{username}!"
    # socket.broadcast.emit("#{username} sent: #{message}")     

