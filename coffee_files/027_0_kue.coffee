# # Kue Jobs
#***   
# * [Kue](http://learnboost.github.com/kue/)
# 
#***   
# 

kue = require 'kue'
jobs = kue.createQueue()
# sending email to see the progress
sequence = 0

setInterval ->
  sequence += 1  
  ((sequence) ->
    job = jobs.create 'email',
      title: 'Hello',
      to: 'nodetuts_in_coffeescript@iscool.com',
      body: 'Hello from Node Tuts!'
    .attempts(5).priority('high').save()   
    #  you can delay this job in mil sec   
    # .attempts(5).priority('high').delay(100).save()

    job.on 'complete', ->
      console.log "job #{sequence} completed!"

    job.on 'failed', ->
      console.log "job #{sequence} failed"
      
    job.on 'progress', (percentComplete) ->
      console.log "job #{sequence} is #{percentCompte}% completed"
      
  )(sequence)
, 1000                                             

# you can verify these jobs at http://localhost:3000
kue.app.listen 3000