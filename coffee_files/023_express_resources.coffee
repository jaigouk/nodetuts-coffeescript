# # Express resources
#***   
# * [express-resource](https://github.com/visionmedia/express-resource) - Resourceful routing for Express
#***  

express= require('express')
resource= require('express-resource')



app = express.createServer()

app.configure ->
  app.use express.methodOverride()
  app.use express.bodyParser()
  app.use app.router
  
app.configure 'development', ->
  app.use express.static __dirname + '/static'
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler
  oneYear = 31557600000
  app.use express.static __dirname + '/static',
    maxAge: 33
  app.use express.errorHandler()

# #Modules 
# nesting forumns for each product
products = app.resource 'products', require './modules_023/products'
forums = app.resource 'forums', require './modules_023/forums'
products.add(forums)
# products.load(Product.load)
# forums.load(Forum.load)
app.listen 4000