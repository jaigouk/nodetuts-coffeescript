# # Building Node.js Modules
 
string_length = null
# returns a random string with a specified length

module.exports.generate = (string_length) ->
  string_lengh = 6 if string_length is 0
  chars = "asdfsdfgfdghwertqwegpkap"
  randomstring = ''
  for x in [0..string_length]
    rnum = Math.floor Math.random() * chars.length
    randomstring += chars.substring(rnum, rnum + 1)
  randomstring

# So, module behaves like a singleton clsas  
module.exports.setLength = (length) ->
  string_length = length

# Because string_length is a global variable in this module  
# now we can use this module like this,
# rs = require('017_module')
# rs.setLength(20)
# rs.genterate()  


# Let's say, we need a pseudo class.
# It's fun to use coffeescript! :D
class RandomStringGenerator 
  constructor: (@string_length = 6) -> 
  setLength: (length) -> @string_length = length
  generate: ->
    chars = "asdfsdfgfdghwertqwegpkap"
    randomstring = ''
    for x in [0...@string_length]
      rnum = Math.floor Math.random() * chars.length
      randomstring += chars.substring(rnum, rnum + 1)
    randomstring    
 
module.exports = RandomStringGenerator 

# We can expose a create function as a factory method.
# But it's not open for extension.
module.exports.create = (string_length) ->
  new RandomStringGenerator(string_length)  
  
  
# Here is another class example in pragprog coffeescript book.  
#` class Shape`
#`   constructor: (@width) ->`
#`   computeArea: -> throw new Error('I am an abstract class!')`
# 
#` class Square extends Shape`
#`   computeArea: -> Math.pow @width, 2`
# 
#` class Circle extends Shape`
#`   radius: -> @width / 2`
#`   computeArea: -> Math.PI * Math.pow @radius(), 2`
# 
#` showArea = (shape) ->`
#`   unless shape instanceof Shape`
#`     throw new Error('showArea requires a Shape instance!')`
#`   console.log shape.computeArea()  `

# class B extends A
# B's prototype inherits from A's prototype. In addition, A's class-level 
# properties are copied over to B.
# The one exception: B.name would be 'B  while A.name would be 'A'
# -- name is a special property