# # File upload
#***   
# * [multipart-js](http://github.com/isaacs/multipart-js/)
# It seems that there's no multipart package in npm registry now
# So, I'm going to use another one.
# With some googling, I found this
# http://stackoverflow.com/questions/6366463/nodejs-express-and-file-uploading
# And there's a express multipart example.
# https://github.com/visionmedia/express/blob/master/examples/multipart/app.js
#
# * [connect-form](https://github.com/visionmedia/connect-form) - urlencoded / multipart form parsing middleware for Connect

# connect-form uses Formidable.
# https://github.com/felixge/node-formidable
#***   
#  

express = require 'express' 
form = require 'connect-form'
util = require 'util'
# connect-form middleware uses the formidable middleware to parse urlencoded and multipart form data               

# If you want the files written to incomingForm.uploadDir to include the extensions of the original files, set this property to true.                          
#
# `maxFieldsSize = 2 * 1024 * 1024`
#
# Limits the amount of memory a field (not file) can allocate in bytes. I this value is exceeded, an 'error' event is emitted. The default size is 2MB.

# We have to use binary instead of utf-8.
# 
# https://github.com/felixge/node-formidable 
app = express.createServer form 
  keepExtensions: true 
  encoding: 'binary'
  uploadDir: __dirname + '/static/uploads/photos'
  maxFieldsSize: 2 * 1024 * 1024

app.configure ->     
  app.use express.logger()         
  app.use express.bodyParser() 
  app.use express.methodOverride()
  app.use express.static(__dirname + '/static')
  
app.configure 'development', ->  
  app.use express.errorHandler
    dumpExceptions: true,
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler


app.set 'views', __dirname + '/views_012'
app.set 'view engine', 'jade'


app.get '/', (req, res) ->
  res.render 'root' 

# Photos
photos = require './012_1_photos'  
app.get '/photos/new', (req, res) ->
  res.render 'photos/new'         
  
app.get '/photos', (req, res) ->
  photos.list (err, photo_list) ->    
    res.render 'photos/index', locals: {photos: photo_list}
  
app.post '/photos', (req, res, next) -> 

  # connect-form adds the req.form object
  # we can (optionally) define onComplete, passing
  # the exception (if any) fields parsed, and files parsed
  req.form.complete (err, fields, files) ->
    if err
      next err
    else
      console.log "\nuploaded #{files.image.filename} to #{files.image.path}"
      res.redirect "/photos"
  
  req.form.on "progress", (bytesReceived, bytesExpected) ->
    percent = (bytesReceived / bytesExpected * 100) | 0
    process.stdout.write "Uploading: #{percent}% \r"


# Products          
products = require './012_2_products'    
app.get '/products', (req, res) ->
  res.render 'products/index', locals: {products: products.all}

app.get '/products/new', (req, res) ->  
  photos.list (err, photo_list) ->   
    throw err if err  
    res.render 'products/new', locals:
      product:
        req.body && req.body.product || products.new()
      photos: photo_list
      
app.post '/products', (req,res) -> 
  id = products.insert(req.body.product)
  res.redirect '/products/'+id


app.post '/products/:id', (req, res) ->
  id = req.params.id
  products.set(id, req.body.product)  
  res.redirect '/products/'+id
    
app.get '/products/:id', (req, res) -> 
  product = products.find(req.params.id)   
  res.render 'products/show3', locals: {product: product}

app.get '/products/:id/edit', (req, res) -> 
  product = products.find(req.params.id)   
  photos.list (err, photo_list) ->
    throw err if err    
    res.render 'products/edit', locals: 
      product: product
      photos: photo_list
      
app.listen 4000
