# # Starting with everyauth
#***   
# * [everyauth](https://github.com/bnoguchi/everyauth)
# * [cradle](https://github.com/cloudhead/cradle) - the high-level, caching, CouchDB library
# 
#***   
# In episode 18, I used [authenticate](http://jaigouk.com/docs/018_3_users.html) method with mongoose before.
# In this episode, I will stick with everyauth.
    
express = require 'express'
everyauth = require 'everyauth'
util = require 'util'
users = require './026_1_users'

everyauth.twitter
.consumerKey('OExJ9lyDkQlaedNVB6QQ')
.consumerSecret('qDOXx67ArhbiA6fYeGOuxgbMYyph0hiJmMfEDtosc')
.findOrCreateUser (session, accessToken, accessTokenSecret, twitterUserData)->
  promise = @Promise()
  users.findOrCreateByTwitterData(twitterUserData, accessToken, accessTokenSecret, promise)
  promise
.redirectPath('/')
 
# bodyParser, cookieParser and session are needed for login
app = express.createServer()
app.configure ->
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session {secret: "90ndsj9dfdsf"}
  app.use everyauth.middleware()
  app.use app.router
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views_026'
  app.use express.static __dirname + '/static'
  app.use express.errorHandler()
  everyauth.helpExpress(app)
  
app.get '/', (req, res) ->
  res.render 'home'

# Before running this app,
# you need to modify /etc/host file
# 127.0.0.1 dev.nodetuts.com
app.listen 4000             
# and after running this app,
# visit dev.nodetuts.com
