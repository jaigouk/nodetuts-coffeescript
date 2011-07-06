vows = require 'vows'
assert = require 'assert'

theGoodThings = require './the-good-things'
Strawberry = theGoodThings.Strawberry
Banana = theGoodThings.Banana
PeeledBanana = theGoodThings.PeeledBanana
vows.describe('The Good Things')
.addBatch

  'A strawberry':
    topic: new Strawberry,
    'is red': (strawberry) ->
      assert.equal strawberry.color, '#ff0000'
    'and tasty': (strawberry) ->
      assert.isTrue strawberry.isTasty()

  'A banana':
    topic: new Banana
    'when peeled *synchronously*':
      topic: (banana) -> return banana.peelSync()
      "returns a 'PeeledBanana'": (result) -> 
        assert.instanceOf result, PeeledBanana
    'when peeled *asynchronously*': 
      topic: (banana) ->
        banana.peel this.callback
      "returns a 'PeeledBanana'": (err, result) ->
        assert.instanceOf result, PeeledBanana
.export(module)
      

