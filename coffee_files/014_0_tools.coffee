# # Tools
#*** 
# ## [Nodemon](https://github.com/remy/nodemon)    
# 
# For use during development of a node.js based application.
# nodemon will watch the files in the directory that nodemon was started, and if they change, it will automatically restart your node application.
#
# nodemon does not require any changes to your code or method of development. nodemon simply wraps your node application and keeps an eye on any files that have changed.
# 
#***                     
# ## [Spark2](https://github.com/davglass/spark2)
# :( Spark is not maintained. HT says use cluster instead.
#***
# ## [Cluster](http://learnboost.github.com/cluster/)
# extensible multi-core server management for nodejs.
# extensible via plugins
# zero-downtime reload
# various signal support
# hard shutdown support
# graceful shutdown support
# resuscitates workers
# workers commit suicide when master dies
# spawns one worker per cpu (by default)
#
# [API doc](http://learnboost.github.com/cluster/docs/api.html)
#***
# ## [node-inspector](https://github.com/dannycoates/node-inspector)
# Web inspector based Node.js debugger
# [Video Tutorial](http://www.youtube.com/watch?v=AOnK3NVnxL8&feature=player_embedded)
#                                 
# ### Use node-inspector with Coffeescript!
# #### Step1
#
# In a new terminal tab, run the node-inspector
#
# `node-inspector&`                            
#
# #### Step2  
#                      
# Complie & watch the source file in another terminal tab  
#
# `coffee -cw 014_0_tools.coffee`
#
# #### Step3
# In a new terminal tab, run the javascript file
#
# `node --debug 014_0_tools.js`  
#
#
http = require 'http'
 
http.createServer (req,res) ->
  console.log("#{req.method} #{req.url}")
  res.writeHead 200
  res.end 'Hello World2'
.listen 4000      
