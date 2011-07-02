# # Connect
#*** 
# * [Connect Doc](http://senchalabs.github.com/connect/) - Connect is a middleware layer for Node.js   
# * [Connect - Examples](https://github.com/senchalabs/connect/tree/master/examples) 
# * [HowToNode Article by creationix](http://howtonode.org/connect-it) (Thursday July 28, 2010)
# * [Connect Milddleware list](https://github.com/senchalabs/connect/wiki)
#***
http = require('http')

server = http.createServer (req, res) ->
  console.log 'new req'
  res.writeHead 200,
    'Content-Type': 'text/pain'
  res.end 'Hello World'

server.listen 4000, 'localhost'

http = require('http')

server = http.createServer (req, res) ->
  console.log 'new req'
  res.writeHead 200,
    'Content-Type': 'text/pain'
  res.end 'Hello World'

server.listen 4000, 'localhost'