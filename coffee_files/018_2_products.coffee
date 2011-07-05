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
mongoose= require('mongoose') 
Schema = mongoose.Schema
      
Product = new Schema
  name: 
    type: String
    index: true
    # required: true
  description: 
    type: String
    index: true
    # required: true
  price: 
    type: Number
    index: true
    # required: true    
    default: 0
  photo:
    type: String
    
mongoose.model 'Product', Product   



# expensive: (price) ->    
#   MongooseProduct.namedscope 'expensive', (price) ->
#     this.where('age').gte(1000)

module.exports = Product       
# ## Named scopes in mongoose
# User.female.thirties.find (err, found) ->
#   console.log name for name in found
#   
# User.female.olderThan(30).youngerThan(40).find (err, found) ->
#   # do something
#   
# UserSchema.namedscope 'olderThan', (age) ->
#   this.where('age').gte(age)
#   
# UserSchema.namedscope 'youngerThan', (age) ->
#   this.where('age').lt(age)
#   
# UserSchema.namedscope('thirties').olderThan(30).youngerThan(40)
# 
#   
# Product.namedscope 'expensive', (price) ->
#   this.where('age').gte(1000)   

# Before using mongoose
#
# module.exports.all = products 
# 
# products = [ 
#   id: 1
#   name: 'Mac Book Pro'
#   description: 'Apple 13 inch Mac Book Pro Notebook'
#   price: 1000
# , 
#   id: 2
#   name: 'iPad'
#   description: 'Apple 64GB 3G iPad'
#   price: 899
# ]              
# module.exports.find = (id) ->
#   id = parseInt(id, 10)                                    
#   for product in products 
#     if product.id is id then return product 
# 
# module.exports.set = (id, product) ->
#   id = parseInt(id, 10)          
#   product.id = id
#   products[id - 1] = product
#     
# module.exports.new = () ->
#   name : ''
#   description: ''
#   price: 0
#   
# module.exports.insert = (product) ->
#   id = products.length + 1
#   product.id = id
#   products[id - 1] = product
#   id    
