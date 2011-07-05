# # MongoDB and Mongoose
#***   
# * [MongoDB](http://www.mongodb.org/)
# * [mongoose](http://mongoosejs.com/) - 1028 watchers, 89 forks! 
# * **[Mongoose Talk: Rapid Realtime App Development with Node.JS & MongoDB](http://www.10gen.com/presentation/mongosf2011/nodejs)** - **Highly Recommended**
#***
# # Mongoose Plugins
# * [mongoose-types](https://github.com/bnoguchi/mongoose-types) -Types include: Email, Url
# * [mongoose-auth](https://github.com/bnoguchi/mongoose-auth) - password, facebook, twitter, github, instagram
#***

# Schema, Static definition are changed in mongoose 1.5.0.
# It took some time for me. I consulted mongoose API.

mongoose= require('mongoose') 
Schema = mongoose.Schema

User = new Schema
  login: 
    type: String
    index: true
    required: true
    unique: true
  password:
    type: String
    index: true    
    required: true    
  role:
    type: String
    index: true   
    required: true
    default: 'user'     

# http://mongoosejs.com/docs/api.html
# Schema.prototype.static = function(name, fn) {
#   if ('string' != typeof name)
#     for (var i in name)
#       this.statics[i] = name[i];
#   else
#     this.statics[name] = fn;
#   return this;
# };
# Defines a static method
# param: String name
# param: Function handler
# api: public        
#
# I used schema's staic here. 
# pass login, password and callback function. 
# result would be array. so, I am returning callback with a first one. 
#
# And for the authentication, I will use [mongoose-auth](https://github.com/bnoguchi/mongoose-auth) or [everyauth](https://github.com/bnoguchi/everyauth) later.
User.static 'authenticate', (login, password, callback) ->
  # Another find Example
  # User.find({}, ['field']).sort([['date'], -1).limit(10).run(function(err, docs){
  #
  #}).     
  
  this.findOne login: login, password: password, (err, user) ->
    throw err if err
    callback(err, user)


mongoose.model 'User', User    

# 
# Before using mongoose...
#      
# users =
#   pedro:
#     login: 'pedro'
#     password: 'test1'
#     role: 'admin'
#   john:
#     login: 'john'
#     password: 'test2'
#     role: 'user'
#   admin:
#     login: 'admin'
#     password:  'admin'
#     role: 'admin'   
#  
# module.exports.authenticate = (login, password, callback) ->
#   user = users[login]
#   return callback(null) unless user
#   return callback(user) if user.password is password   

  