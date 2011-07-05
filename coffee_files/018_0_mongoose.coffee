# # MongoDB and Mongoose
#***   
# * [MongoDB](http://www.mongodb.org/)
# * [mongoose](http://mongoosejs.com/) - 1028 watchers, 89 forks! 
# * **[Mongoose Talk: Rapid Realtime App Development with Node.JS & MongoDB](http://www.10gen.com/presentation/mongosf2011/nodejs)** - **Highly Recommended**
#***

express= require 'express'
form = require 'connect-form'
util= require('util')
RedisStore = require('connect-redis')(express)

# connecting / initializing db
mongoose= require('mongoose')
db = mongoose.connect('mongodb://localhost/nodetuts')


app = express.createServer form 
  keepExtensions: true 
  encoding: 'binary'
  uploadDir: __dirname + '/static/uploads/photos'
  maxFieldsSize: 2*1024*1024

app.configure () ->     
  app.use express.logger()         
  app.use express.bodyParser() 
  app.use express.methodOverride()
  app.use express.static(__dirname + '/static')
  # There're other session stores like redis, memcache
  # We're going to use express' session store  
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
    
app.configure 'development', () ->  
  app.use express.errorHandler
    dumpExceptions: true,
    showStack: true

app.configure 'production', () ->
  app.use express.errorHandler

app.set 'views', __dirname + '/views_018'
app.set 'view engine', 'jade'
photos = require './018_1_photos'  
require './018_2_products'    
require './018_3_users'  


# Helpers
app.dynamicHelpers
  session: (req, res) ->
    req.session
  flash: (req, res) ->
    req.flash()         

# sessions
User = db.model('User')

app.get '/sessions/new', (req, res) ->
  res.render 'sessions/new', locals: redir: req.query.redir

app.post '/sessions', (req, res) ->
  User.authenticate req.body.login, req.body.password , (err, user) ->
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
 
# Products          
Product = db.model('Product') 

app.get '/products', requiresLogin, (req, res) -> 
  Product.find (err, found) ->
    throw err if err
    res.render 'products/index', locals: products: found

app.get '/products/new', requiresLogin, (req, res) ->  
  photos.list (err, photo_list) ->   
    throw err if err  
    res.render 'products/new', locals:
      product:
        req.body && req.body.product || new Product("john", "doe","2","")
      photos: photo_list
      
app.post '/products', requiresLogin, (req,res) -> 
  product = new Product(req.body.product)
  product.save (err, product) ->
    if err                   
      req.flash 'warn', "Oops, failed to save."
      res.redirect '/products'  
    else 
      req.flash 'ok', "Successfully updated."
      res.redirect '/products/'+product.id


app.post '/products/:id', requiresLogin, (req, res) -> 
  Product.findById req.params.id, (err, found) ->
    console.log err
    console.log JSON.stringify found
    throw err if err
    found.name = req.body.product.name
    found.price = req.body.product.price
    found.description = req.body.product.description
    found.photo = req.body.product.photo
    found.save (err, found) ->
      if err 
        req.flash 'warn', "Oops, failed to update."
        res.redirect '/products/'+found.id     
      else                                         
        req.flash 'ok', "Successfully updated."
        res.redirect '/products/'+found.id
    
app.get '/products/:id', (req, res) -> 
  Product.findById req.params.id, (err, product) ->
    throw err if err
    res.render 'products/show', locals: product: product

app.get '/products/:id/edit', requiresLogin, (req, res) -> 
  Product.findById req.params.id, (err1, found) ->
    throw err1 if err1 
    photos.list (err2, photo_list) ->
      throw err2 if err2    
      res.render 'products/edit', locals: 
        product: found
        photos: photo_list
  

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
      
app.listen 4000