
class theGoodThings
  constructor: (@Strawberry, @Banana) ->
    @Strawberry = new Strawberry
    @Banana = new Banana
  
class Strawberry 
  constructor: (@color='#ff000') ->
  isTasty: ->
    true
class Banana 
  constructor: (@color='yellow') ->


module.exports.theGoodThings = theGoodThings

