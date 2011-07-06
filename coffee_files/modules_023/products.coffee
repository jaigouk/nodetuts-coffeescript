util= require('util')

exports.index = (req, res) ->
  res.send 'products#index'

exports.new = (req, res) ->
  res.send 'products#new'

exports.create = (req, res) ->
  res.send 'products#create'

exports.show = (req, res) ->
  res.send 'product#show' + util.inspect(req.product)

exports.edit = (req, res) ->
  res.send 'products#edit' + util.inspect(req.product)
  
exports.update = (req, res) ->
  res.send 'products#update'
  
exports.destroy = (req, res) ->
  res.send 'products#destroy'
  
# auto loading
exports.load = (id, callback) ->
  callback null,
    id: id
    name: "Product # #{id}"