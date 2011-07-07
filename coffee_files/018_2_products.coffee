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
mongoose = require 'mongoose'
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

# Another possible namedscope.
#
#` expensive: (price) ->`   
#
#`   MongooseProduct.namedscope 'expensive', (price) ->`
#
#`     this.where('age').gte(1000)`

module.exports = Product       