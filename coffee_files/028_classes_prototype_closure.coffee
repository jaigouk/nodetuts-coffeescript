# # classes, prototypes and closures
# The souce code bellow works almost same except for the encapsulation of @a, @b, @coalesce
#
#`class Adder`  
#
#`  constructor: (@a, @b)->`    
#     
#`  coalesce: ->`
#
#`    unless @a then @a = 0`
#
#`    unless @b then @b = 0`   
#        
#`  add: ->`       
#
#`     @coalesce()`
#
#`     console.log (@a + @b).toString()`
# 
#` a1 = new Adder(2,4)`
#
#` console.log a1.b`  
#
#` a1.a = 5`
#
#` console.log a1.a`
#
#` a1.add()`

EventEmitter = require("events").EventEmitter
Adder = (a, b) ->
  coalesce = ->
    a = 0  unless a
    b = 0  unless b
  add = ->
    coalesce()
    that.emit "add", a, b
    a + b
  
  that = add: add
  that.__proto__ = EventEmitter.prototype
  that
  
adder = Adder(1,2)
adder.on 'add', (a, b) ->
  console.log "ADDING #{a} and #{b}"  
  
adder.add()  