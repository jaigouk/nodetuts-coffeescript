# # Express - Part 2
#***   
# * [Express](http://expressjs.com/)
# * [Lots of Exprss examples (github)](https://github.com/visionmedia/express/tree/master/examples)
# * [Node Camp 2010 Routing Workshop](http://camp.nodejs.org/videos/session-03_routing_workshop-guillermo_rauch.html) - source codes are little bit old :( 
# * [Jade](https://github.com/visionmedia/jade) 
#***   
#
products = [ 
  id: 1
  name: 'Mac Book Pro'
  description: 'Apple 13 inch Mac Book Pro Notebook'
  price: 1000
, 
  id: 2
  name: 'iPad'
  description: 'Apple 64GB 3G iPad'
  price: 899
]

module.exports.all = products
               
module.exports.find = (id) ->
  id = parseInt(id, 10)                                    
  for product in products 
    if product.id is id then return product 
