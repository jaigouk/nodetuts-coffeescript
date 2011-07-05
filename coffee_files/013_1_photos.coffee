fs= require('fs')

src_path = __dirname + '/static/uploads/photos'
module.exports.list = (callback) ->
  fs.readdir src_path, (err, files) ->
    ret_files = []    
    ret_files.push("/uploads/photos/#{file}") for file in files
    console.log ret_files
    callback(err, ret_files)