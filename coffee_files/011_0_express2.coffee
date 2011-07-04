# # Express - Part 3  
#***   
# * [Express](http://expressjs.com/)
# * [Lots of Exprss examples (github)](https://github.com/visionmedia/express/tree/master/examples)
# * [Node Camp 2010 Routing Workshop](http://camp.nodejs.org/videos/session-03_routing_workshop-guillermo_rauch.html) - source codes are little bit old :( 
# * [Jade](https://github.com/visionmedia/jade) 
#***   
#  

express= require('express')

app = express.createServer()
         
# Middleware ordering is important.
app.configure () ->     
  app.use express.logger()         
  #By default Express does not know what to do with POST/PUT request body, so we should add the bodyParser middleware, which will parse application/x-www-form-urlencoded and application/json request bodies and place the variables in req.body
  app.use express.bodyParser() 
  #When using methods such as PUT with a form, we can utilize a hidden input named _method, which can be used to alter the HTTP method. To do so we first need the methodOverride middleware, which should be placed below bodyParser so that it can utilize it’s req.body containing the form values.
  app.use express.methodOverride()
  app.use express.static(__dirname + '/static')
  
app.configure 'development', () ->  
  app.use express.errorHandler
    dumpExceptions: true,
    showStack: true

app.configure 'production', () ->
  app.use express.errorHandler


app.set 'views', __dirname + '/views'
app.set 'view engine', 'jade'


app.get '/', (req, res) ->
  res.render 'root'
     
products = require './011_1_products2'
    
app.get '/products', (req, res) ->
  res.render 'products/index', locals: products: products.all

# The order of app.get 'xxx' is important.
# If you put this /products/new below the /product/:id,
# then new would be passed as a param "new".
app.get '/products/new', (req, res) ->
  res.render 'products/new', locals:
    product:
      req.body && req.body.product || products.new()

app.get '/products/:id', (req, res) -> 
  product = products.find(req.params.id)   
  res.render 'products/show2', locals: product: product

app.get '/products/:id/edit', (req, res) -> 
  product = products.find(req.params.id)   
  res.render 'products/edit', locals: product: product

app.put '/products/:id', (req, res) ->
  id = req.params.id
  products.set(id, req.body.product)  
  res.redirect '/products/'+id



app.post '/products', (req,res) -> 
  id = products.insert(req.body.product)
  res.redirect '/products/'+id
  
  
app.listen 4000
