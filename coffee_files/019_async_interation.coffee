# # Asynchronous Iteration Patterns
#***   


# ### Async version  
insertElement = (data, callback) ->
  timeout = Math.ceil Math.random() * 3000
  setTimeout ->
    callback(null, data)      
  , timeout      
           
insertAll = (coll, callback) -> 
  left = coll.length
  for i in [0...coll.length]
    elem = coll[i]
    ((elem) ->
      insertElement elem, (err, _elem) ->
        console.log "[async] #{elem} inserted"
        callback() if --left is 0
    )(elem)

insertAll [1,2,3,4,5,6,7,8,9,10], ->
  console.log '[async] insertAll finished'           

     
# ### Queued version      

qinsertElement = (data, callback) ->
  timeout = Math.ceil Math.random() * 3000
  setTimeout ->
    callback(null, data)      
  , timeout      
           
qinsertAll = (coll, callback) ->  
  queue = coll.slice(0)
  elem = null  
  # we wrap with (iterate code)() and iterate queue
  (iterate = ->
    if queue.length is 0
      callback()  
      # should return. Without this, it will callback forever.
      return
    elem = queue.splice(0,1)[0]
    qinsertElement elem, (err, elem) ->
      throw err if err
      console.log  elem + ' inserted'              
      # we can get out of stack either by callling setTimeout
      # or nexTick...
      setTimeout iterate, 0
      # process.nextTick () ->
      #   iterate()
  )()  
    
qinsertAll [1,2,3,4,5,6,7,8,9,10], ->
  console.log '[que] insertAll finished'  