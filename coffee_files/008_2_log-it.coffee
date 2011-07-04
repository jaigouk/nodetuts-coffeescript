# # Connect
#*** 
# * [Connect Doc](http://senchalabs.github.com/connect/) - Connect is a middleware layer for Node.js   
# * [Connect - Examples](https://github.com/senchalabs/connect/tree/master/examples) 
# * [HowToNode Article by creationix](http://howtonode.org/connect-it) (Thursday July 28, 2010)
# * [Connect Milddleware list](https://github.com/senchalabs/connect/wiki)
#***
util= require('util')
module.exports = () ->
  counter = 0
  (req, res, next) ->
    writeHead = res.writeHead                              
    counter += 1
    res.writeHead = (code, headers) ->
      res.writeHead = writeHead
      console.log "Response: #{counter} #{code} #{util.inspect(headers)}"
      res.writeHead(code, headers) 
    # # Don't forget to call next()  
    next()