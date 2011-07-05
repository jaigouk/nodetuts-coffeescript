RSG = require './017_0_modules'
rsg1 = new RSG 
# prints kqqrdf
console.log rsg1.generate()   

rsg1.setLength(20) 
# prints fdggasewkadpepgfdgss
console.log rsg1.generate()    

# We can have two different random strings
# We have two instances with it's own state.
rsg2 = new RSG
rsg2.generate()

rsg3 = RSG.create(15)