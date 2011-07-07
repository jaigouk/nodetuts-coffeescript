# # Steps
#***   
# * [Step ](https://github.com/creationix/step) - An async control-flow library that makes stepping through logic easy.
#***   
http = require 'http'
fs = require 'fs'
step = require 'step'

file_path = __dirname + '/asset/cat.jpg'
file_size = null

# The step library exports a single function called Step. It accepts any number of functions as arguments and runs them in serial order using the passed in this context as the callback to the next step.

step get_file_size = ->
  fs.stat file_path, this
, store_file_size = (err, stat) ->
  throw err  if err
  file_size = stat.size
  this
, read_file_into_memory = () ->
  fs.readFile file_path, this
, create_server = (err, file_content) ->   
  throw err  if err 
  http.createServer (request, response) ->
    response.writeHead 200,
      'Content-Type': 'image/jpeg'
      'Content-Length': file_size 
    response.end file_content
  .listen 4000