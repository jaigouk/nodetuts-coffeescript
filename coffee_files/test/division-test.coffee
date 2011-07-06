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

# I will try to use vows.
#
# Let's say, we want a single page web app
# that can handle email sending. A contact page would be 
# apropriate. 
# 
# As a visotor
# I want to send a email in a contact page
# So that I can contact this web developer for a new project
#
# Scenario - I forgot to enter my email or name
# Scenario - I typed all the info and clicked submit button
# Scenario - Server Error?
# Scenario - I'm evil
# Scenario - I'm a short tempered person. clicking submit madly.
# Scenario - I'm a hacker, I will ddos your server! 

vows= require('vows')
assert= require('assert')

vows
.describe('Division by zero')

.addBatch
  'when dividing a number by zero':
    topic: -> 42 / 0
    'we get Infinity' : (topic) ->
      assert.equal topic, Infinity
    
  'but when dividing zero by zero':
    topic: -> 0 / 0
    'we get a value which':
      'is not a number': (topic) ->
        assert.isNaN topic
      'is not equal to itself': (topic) ->
        assert.notEqual topic, topic
      
.run()
