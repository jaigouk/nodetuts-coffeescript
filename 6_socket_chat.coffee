http= require('http')
fs= require('fs')
sys= require('sys')
ws= require('./asset/ws.js')

clients = []

http.createServer (req, res) ->
  res.writeHead 200,
    'Content-Type': 'text/html'    
  rs = fs.createReadStream __dirname + '/asset/template.html'
  sys.pump(rs, res)

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