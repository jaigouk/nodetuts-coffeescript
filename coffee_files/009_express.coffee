# # Express - Part 1
#***   
# * [Express](http://expressjs.com/)
# * [Lots of Exprss examples (github)](https://github.com/visionmedia/express/tree/master/examples)
# * [Node Camp 2010 Routing Workshop](http://camp.nodejs.org/videos/session-03_routing_workshop-guillermo_rauch.html) - source codes are little bit old :( 
# * [Jade](https://github.com/visionmedia/jade) - 
#***   
#

express= require('express')

app = express.createServer()
# # Middleware   
# Middleware ordering is important, when Connect receives a request the first middleware we pass to createServer() or use() is executed with three parameters, request, response, and a callback function usually named next. When next() is invoked the second middleware will then have it’s turn and so on. This is important to note because many middleware depend on each other, for example methodOverride() checks req.body.method for the HTTP method override, however bodyParser() parses the request body and populates req.body.
app.configure 'development', () ->
  app.use express.logger()
  app.use express.errorHandler
    dumpExceptions: true,
    showStack: true

app.configure 'production', () ->
  app.use express.logger()
  app.use express.errorHandler

# don't forget to add / infront of views...
app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'
app.set 'view options', {layout: true}
# # Route Middleware
# To keep things DRY and to increase readability we can apply this logic within a middleware. Multiple route middleware can be applied, and will be executed sequentially to apply further logic such as restricting access to a user account. Keeping in mind that middleware are simply functions, we can define function that returns the middleware in order to create a more expressive and flexible solution
app.get '/', (req, res) ->

  res.render 'root.jade'
  
app.listen 4000
