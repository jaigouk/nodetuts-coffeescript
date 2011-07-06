util= require('util')

exports.index = 
  (req, res) ->
    res.send 'index of forum'

  xml: (req, res) ->  
    res.send 'xml requested'
  json: (req, res) ->
    res.send 'json requested'

exports.new = (req, res) ->
  res.send 'forums#new'

exports.create = (req, res) ->
  res.send 'forums#create'

exports.show = (req, res) ->
  res.send 'forum#show' + util.inspect(req.product)

exports.edit = (req, res) ->
  res.send 'forums#edit' + util.inspect(req.product)
  
exports.update = (req, res) ->
  res.send 'forums#update'
  
exports.destroy = (req, res) ->
  res.send 'forums#destroy'
  
# auto loading
# exports.load = (id, callback) ->
#   callback null,
#     id: id
#     name: "Forum # #{id}"         