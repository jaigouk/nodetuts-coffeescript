
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

module.exports.set = (id, product) ->
  id = parseInt(id, 10)          
  product.id = id
  products[id - 1] = product
    
module.exports.new = () ->
  name : ''
  description: ''
  price: 0
  
module.exports.insert = (product) ->
  id = products.length + 1
  product.id = id
  products[id - 1] = product
  id
