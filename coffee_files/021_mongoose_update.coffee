# # MongoDB and Mongoose (1.5.0)
#***   
# * [MongoDB](http://www.mongodb.org/)
# * [mongoose](http://mongoosejs.com/) - 1028 watchers, 89 forks! 
# * **[Mongoose Talk: Rapid Realtime App Development with Node.JS & MongoDB](http://www.10gen.com/presentation/mongosf2011/nodejs)** - **Highly Recommended**
#***
# # Mongoose Plugins
# * [mongoose-types](https://github.com/bnoguchi/mongoose-types) -Types include: Email, Url
# * [mongoose-auth](https://github.com/bnoguchi/mongoose-auth) - password, facebook, twitter, github, instagram
#***

# I've already covered most of this episode's updates
# in the episode 18. 
# Just watch **[Mongoose Talk: Rapid Realtime App Development with Node.JS & MongoDB](http://www.10gen.com/presentation/mongosf2011/nodejs)** - **Highly Recommended**

mongoose= require('mongoose')
Schema = mongoose.Schema

PostSchema = new Schema
  title: String
  body: String
  date: 
    type: Date
    default: Date.now
  state:
    type: String
    enum: ['draft', 'published', 'private']     
  author:
    email:  
      name: String
      type: String  
      validate: /^([a-zA-Z0-9_.-])+@(([a-zA-Z0-9-])+.)+([a-zA-Z0-9]{2,4})+$/
  comments: [CommentSchema]
  
CommentSchema = new Schema
  email: String
  body: String

      
# ## Named scope example
#
#` User.female.thirties.find (err, found) ->`
#
#`   console.log name for name in found`
#   
#` User.female.olderThan(30).youngerThan(40).find (err, found) ->`
#
#   `# do something`
#
#   
#` UserSchema.namedscope 'olderThan', (age) ->`
#
#`   this.where('age').gte(age)`
#
#   
#` UserSchema.namedscope 'youngerThan', (age) ->`
#
#`   this.where('age').lt(age)`
#   
# `UserSchema.namedscope('thirties').olderThan(30).youngerThan(40)      `

PostSchema.namedscope 'recent', (days) ->
  this.where('date').gte(Date.now() - 1000*60*60*24*days)

PostSchema.virtual('shortBody').get ->
  this.body.substring(0, 4)

mongoose.connect 'mongodb://localhost/mydatabase'
mongoose.model 'Post', PostSchema

Post = mongoose.model 'Post'
post = new Post()
post.title = 'My first blog title'
post.body = 'Post body'
post.state = 'published'
post.author.name = 'Jaigouk'
post.author.email = 'jaigouk@gmail.com'
post.comments.push
  email: 'pedro.teixeira@gmail.com'
  body: 'coffeescript is awesome'
  
post.save (err) ->
  throw err if err
  console.log 'saved' 
  console.log ''
  Post.recent(5).find (err, found) ->
    throw err if err
    console.log post.shortBody for post in found  
  mongoose.disconnect()
