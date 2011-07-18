# # Starting with everyauth
#***   
# * [everyauth](https://github.com/bnoguchi/everyauth)
# * [cradle](https://github.com/cloudhead/cradle) - the high-level, caching, CouchDB library
# 
#***

cradle = require "cradle"
util = require "util"
c = new cradle.Connection("nodetuts26.iriscouch.com", 80, auth: 
  username: "node"
  password: "tuts"
)
users = c.database("users")
exports.findOrCreateByTwitterData = (twitterUserData, accessToken, accessTokenSecret, promise) ->
  users.view "docs/twitterId", key: twitterUserData.id_str, (err, docs) ->
    if err
      console.log "Error using users/_design/docs/_view/twitterId:"
      console.log err
      promise.fail err
      return
    if docs.length > 0
      user = docs[0].value
      console.log "user exists: " + util.inspect(user)
      promise.fulfill user
    else
      doc = 
        accessToken: accessToken
        accessTokenSecret: accessTokenSecret
        name: twitterUserData.name
        twitterId: twitterUserData.id
      
      c.database("users").save doc, (err, res) ->
        if err
          console.log "Error using users:"
          console.log err
          promise.fail err
          return
        console.log "user created: " + util.inspect(doc)
        promise.fulfill doc
