# # Unit tests and TDD in node.js
#***     

# # TDD Lib Ranking (5th July, 2011)   
#
# ### Gibhub (#watchers)
# * [Jasmine](https://github.com/pivotal/jasmine/wiki) - 1504
# * [vows](https://github.com/cloudhead/vows) - 457  
# * [Expresso](http://visionmedia.github.com/expresso) - 401 
# * [should.js](http://github.com/visionmedia/should.js) - 114 
#***     
#
# ### [npm registry](http://search.npmjs.org/) (#depended on)
# * vows - 48
# * expresso - 12   
# * should - 6
# * jasmine-node - 4
#***                     
#
# ### [NodeCloud Ranking (ranking#)](http://www.nodecloud.org/)
# * vows - 23
# * expresso - no ranking
# * should - no ranking
# * jasmine-node - no ranking


vows = require 'vows'
fs = require 'fs'
assert= require 'assert'

vows
.describe('Division by zero')

.addBatch
 'when dividing a number by zero':
   #topic is function and returns a value
   topic: -> 42 / 0                      
   # the topic value is used as an argument
   'we get Infinity' : (topic) ->
     assert.equal topic, Infinity

 'but when dividing zero by zero':         
   #topic is only run once. Hence the value is different from
   # example value above
   topic: -> 0 / 0
   'we get a value which':
     'is not a number': (topic) ->
       assert.isNaN topic
     #topic has a scope. we use the same 0 / 0 value here.
     'is not equal to itself': (topic) ->
       assert.notEqual topic, topic       


 
# ## Writing asynchronous tests

.addBatch
  'A introduction file':
    topic: ->    
      # this.callback function is available inside all topics
      # When this.callback is called, it passes on the arguments
      # it received to the test functions, one by one, as if 
      # the values were returned by the topic function itself.
      # this allows us to decouple callback from they async function call
      # topics which do not return anything must take use of 'this.callback'
      fs.stat '000_intro.coffee', this.callback
    'can be accessed': (err, stat) ->
      # we have no err
      assert.isNull err
      # we have a stat object
      assert.isObject stat
    'is not empty': (err, stat) ->
      # the file size is > 0
      assert.isNotZero stat.size
                      
.run()   