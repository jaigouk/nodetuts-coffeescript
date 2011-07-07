# # Express - Part 2  
#***   
# * [Express](http://expressjs.com/)
# * [Lots of Exprss examples (github)](https://github.com/visionmedia/express/tree/master/examples)
# * [Node Camp 2010 Routing Workshop](http://camp.nodejs.org/videos/session-03_routing_workshop-guillermo_rauch.html) - source codes are little bit old :( 
# * [Jade](https://github.com/visionmedia/jade) 
#***   
#  

express= require('express')

app = express.createServer()
         

app.configure ->
  app.use express.logger()
  app.use express.static(__dirname + '/static')
  
app.configure 'development', ->  
  app.use express.errorHandler
    dumpExceptions: true,
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler


app.set 'views', __dirname + '/views_010'
app.set 'view engine', 'jade'
# `view options, {layout: true}` is default
# so, we don't need to write this line
# app.set 'view options', {layout: true}

app.get '/', (req, res) ->
  res.render 'root'
     
products = require './010_1_products'
    

# I was really confused.. 
# Everything was fine, but the partial in the /views/products/index.jade was not rendered. 
# 
# * jade           v0.12.4
# * express        v2.4.0
#
#   `products!= partial('product', {collection: products})`
# 
# So, I consulted express' github examples.
# Examples were pretty new. about 3 days old. 
#
# In this express github repo [blog example](https://github.com/visionmedia/express/tree/master/examples/blog/views), 
# 
# There is no partial directory!!!
# just post directory. I renamed partial directory to product. And It works now.
# And I changed the /views/partials/product.jade ====> /views/product/index.jade 

# Still confused?
# have a look at this [express github repo example](https://github.com/visionmedia/express/blob/master/examples/partials/views/ninja/index.jade)
app.get '/products', (req, res) ->
  res.render 'products/index', locals: products: products.all


app.get '/products/:id', (req, res) -> 
  product = products.find(req.params.id)   
  res.render 'products/show', locals: product: product

app.listen 4000
