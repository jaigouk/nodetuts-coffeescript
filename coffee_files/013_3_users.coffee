users =
  pedro:
    login: 'pedro'
    password: 'test1'
    role: 'admin'
  john:
    login: 'john'
    password: 'test2'
    role: 'user'
  admin:
    login: 'admin'
    password:  'admin'
    role: 'admin'
 
module.exports.authenticate = (login, password, callback) ->
  user = users[login]
  return callback(null) unless user
  return callback(user) if user.password is password

  