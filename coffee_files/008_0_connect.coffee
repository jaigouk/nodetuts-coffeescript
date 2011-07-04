# # Connect
#*** 
# * [Connect Doc](http://senchalabs.github.com/connect/) - Connect is a middleware layer for Node.js   
# * [Connect - Examples](https://github.com/senchalabs/connect/tree/master/examples) 
# * [HowToNode Article by creationix](http://howtonode.org/connect-it) (Thursday July 28, 2010)
# * [Connect Milddleware list](https://github.com/senchalabs/connect/wiki)
#***


# got an error :(
# Error: Cannot find module 'qs'
# connect/lib/middleware/bodyParser.js:13 
# So, I typed $npm ls installed connect
# it says,
# UNMET DEPENDENCY mime >= 0.0.1
# UNMET DEPENDENCY qs >= 0.0.6
# $ npm install qs mime
# npm v1.0.13 have some bugs :p

connect= require('connect')

connect.createServer(require('./008_2_log-it')() 
, require('./008_1_serve-js')())
.listen 4000
              
# http://localhost:4000//Users/jaigouk/.vimrc works :D

  
