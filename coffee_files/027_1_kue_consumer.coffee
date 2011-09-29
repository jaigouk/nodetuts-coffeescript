# # Kue Jobs - consumer
#***   
# * [Kue](http://learnboost.github.com/kue/)
# 
#***   
# 

kue = require 'kue'
jobs = kue.createQueue()

# At one batch, we consume 10 tasks.

jobs.process 'email', 10, (job, done) ->
  console.log(job.data)
  setTimeout ->
    try   
      # We can throw err.
      # throw new Error 'some problem happend.'
      console.log('sent email')         
      done()
    catch err
      done err    
  , 300


