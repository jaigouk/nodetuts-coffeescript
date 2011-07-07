# # Connect
#*** 
# * [Connect Doc](http://senchalabs.github.com/connect/) - Connect is a middleware layer for Node.js   
# * [Connect - Examples](https://github.com/senchalabs/connect/tree/master/examples) 
# * [HowToNode Article by creationix](http://howtonode.org/connect-it) (Thursday July 28, 2010)
# * [Connect Milddleware list](https://github.com/senchalabs/connect/wiki)
#***
fs = require 'fs'

module.exports = ->
  (req, res, next) ->    

    fs.readFile req.url.substr(1), (err, data) ->      
      # data is buffer.
      
      #just move on. 
      #some errors like getting a favicon  
      #next if err 
      console.log err if err              
      res.writeHead 200,
       'Content-Type': 'application/javascript'
      res.end data