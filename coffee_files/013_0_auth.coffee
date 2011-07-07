# # Authentication


express= require 'express' 
form = require 'connect-form'
util= require('util')
RedisStore = require('connect-redis')(express)

app = express.createServer form 
  keepExtensions: true 
  encoding: 'binary'
  uploadDir: __dirname + '/static/uploads/photos'
  maxFieldsSize: 2 * 1024 * 1024

app.configure () ->     
  app.use express.logger()         
  app.use express.bodyParser() 
  app.use express.methodOverride()
  app.use express.static(__dirname + '/static')
  # There're other session stores like redis, memcache
  # In nodetuts screencast, he used express' session store.
  # I just wanted to try redis one.  
  # This will be erased when we restart app
  app.use express.cookieParser()
  app.use express.session 
    secret: 'some secret strings'
    store: new RedisStore
 
requiresLogin = (req, res,next) ->
  if req.session.user     
    next()
  else
    res.redirect('/sessions/new?redir='+req.url)
    
app.configure 'development', ->  
  app.use express.errorHandler
    dumpExceptions: true,
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler

app.set 'views', __dirname + '/views_013'
app.set 'view engine', 'jade'
photos = require './013_1_photos'  
products = require './013_2_products'    
users = require './013_3_users'  

# Helpers
app.dynamicHelpers
  session: (req, res) ->
    req.session
  flash: (req, res) ->
    req.flash()         

# sessions

app.get '/sessions/new', (req, res) ->
  res.render 'sessions/new', locals: redir: req.query.redir

app.post '/sessions', (req, res) ->
  users.authenticate req.body.login, req.body.password, (user) ->
    if user
      req.session.user = user    
      res.redirect req.body.redir or '/'
    else
      req.flash 'warn', 'Login failed'
      res.render 'sessions/new', locals: redir: req.body.redir
 
app.get '/sessions/destroy', (req, res) ->
  delete req.session.user
  res.redirect '/sessions/new'

app.get '/', (req, res) ->
  res.render 'root' 

# Photos

app.get '/photos/new', (req, res) ->
  res.render 'photos/new'         
  
app.get '/photos', (req, res) ->
  photos.list (err, photo_list) ->    
    res.render 'photos/index', locals: photos: photo_list
  
app.post '/photos', (req, res, next) -> 

  # connect-form adds the req.form object
  # we can (optionally) define onComplete, passing
  # the exception (if any) fields parsed, and files parsed
  req.form.complete (err, fields, files) ->
    if err
      next err
    else
      console.log "\nuploaded %s to %s", files.image.filename, files.image.path
      res.redirect "/photos"
  
  req.form.on "progress", (bytesReceived, bytesExpected) ->
    percent = (bytesReceived / bytesExpected * 100) | 0
    process.stdout.write "Uploading: %" + percent + "\r"


# Products          

app.get '/products', requiresLogin, (req, res) ->
  res.render 'products/index', locals: products: products.all

app.get '/products/new', requiresLogin, (req, res) ->  
  photos.list (err, photo_list) ->   
    throw err if err  
    res.render 'products/new', locals:
      product:
        req.body && req.body.product || products.new()
      photos: photo_list
      
app.post '/products', requiresLogin, (req,res) -> 
  id = products.insert(req.body.product)
  res.redirect '/products/'+id


app.post '/products/:id', requiresLogin, (req, res) ->
  id = req.params.id
  products.set(id, req.body.product)  
  res.redirect '/products/'+id
    
app.get '/products/:id', (req, res) -> 
  product = products.find(req.params.id)   
  res.render 'products/show3', locals: product: product

app.get '/products/:id/edit', requiresLogin, (req, res) -> 
  product = products.find(req.params.id)   
  photos.list (err, photo_list) ->
    throw err if err    
    res.render 'products/edit', locals: 
      product: product
      photos: photo_list
      
app.listen 4000
