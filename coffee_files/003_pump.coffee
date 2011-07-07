# # Pump Streams 
#***   
# * [Node API doc - Streams](http://nodejs.org/docs/v0.4.9/api/streams.html)
# * [Node API doc - File System](http://nodejs.org/docs/v0.4.9/api/fs.html)
# * [Node API doc - Util](http://nodejs.org/docs/v0.4.9/api/util.html#util.pump)
#***   
# ### Streams

# A stream is an abstract interface implemented by various objects in Node. For example a request to an HTTP server is a stream, as is stdout. 

# **Streams are readable, writable, or both.** All streams are instances of EventEmitter.

http = require 'http'

# ### File System    
# File I/O is provided by simple wrappers around standard POSIX functions. To use this module do require('fs'). All the methods have asynchronous and synchronous forms.
# 
# The asynchronous form always take a completion callback as its last argument. The arguments passed to the completion callback depend on the method, but the first argument is always reserved for an exception. If the operation was completed successfully, then the first argument will be null or undefined.

fs = require 'fs'
util = require 'util'
file_path = __dirname + '/asset/cat.jpg'              

# * fs.stat(path, [callback])
# Asynchronous stat(2). The callback gets two arguments (err, stats) where stats is a `fs.Stats` object.  
#
# * fs.Stats
# Objects returned from fs.stat() and fs.lstat() are of this type. -- stats.isFile(), 
# stats.isDirectory(), 
# stats.isBlockDevice(), 
# stats.isCharacterDevice(), 
# stats.isSymbolicLink() (only valid with fs.lstat()), 
# stats.isFIFO(), 
# stats.isSocket(), 

fs.stat file_path, (err, stat) -> 
  console.log file_path
  throw err if err
            
    
  server = http.createServer (req, res) ->
    res.writeHead 200, 
      'Content-Type': 'image/jpeg'
      'Content-Length': stat.size
    # Returns a new ReadStream object
    # readStream is a Readable Stream.  
    readStream = fs.createReadStream(file_path) 

    # ### util.pump
    # **Experimental** 
    # Read the data from readableStream and send it to the writableStream. When writableStream.write(data) returns false readableStream will be paused until the drain event occurs on the writableStream. callback gets an error as its only argument and is called when writableStream is closed or when an error occurs.  
    util.pump readStream, res, (err) ->
      throw err if err
        

  server.listen 4000
  
