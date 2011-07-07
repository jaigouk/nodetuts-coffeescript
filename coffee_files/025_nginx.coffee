# # Nginx  
#***   
# * [
#***   
# # Installing
# `brew install nginx`
#
#!/usr/bin/env node

express = require 'express'

app = express.createServer()
app.configure ->
  app.use app.router
  app.set 'view engine', 'jade'
  app.use express.static __dirname + '/static'

app.set 'views', __dirname + '/views_012'  

app.get '/', (req, res) ->
  res.render 'root'
  
app.listen '/tmp/acme_node.socket'


