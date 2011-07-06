collected = {}
exports.collect = (measure, time) ->
  if !collected[measure] then collected[measure]= []   
  collected[measure].push time

exports.summarize = ->
  for key, value of collected
    samples = collected[key]
    # console.log  samples
    average = 0       
    sum = 0
    sum += sample for sample in samples
    if samples.length > 0
      average = sum / samples.length
      console.log "#{key} average: #{average} ms"