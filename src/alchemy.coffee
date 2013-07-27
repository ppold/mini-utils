define ->
  zip = (lists...) ->
    numberOfTuples = Math.max.apply(null, (list.length for list in lists))
    tupleList = new Array(numberOfTuples)

    for nil, i in tupleList
      tupleList[i] = (list[i] for list in lists)

  generate_guid = ->
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
      r = Math.random()*16|0
      v = if c is 'x' then r else (r&0x3|0x8)
      return v.toString(16)
    )

  return {zip, generate_guid}